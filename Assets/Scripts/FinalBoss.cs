using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class FinalBoss : MonoBehaviour
{
    public enum BossPhase { Phase1, Phase2, Phase3 }
    public BossPhase currentPhase = BossPhase.Phase1;

    [Header("General Settings")]
    public float maxHealth = 1000f;
    public float phase2HealthThreshold = 666f;
    public float phase3HealthThreshold = 333f;
    private float currentHealth;
    private bool isTransitioning = false;
    private bool isDead = false;

    [Header("References")]
    public Transform player;
    public GameObject shadowObject;
    public Collider bossCollider;
    public Animator bossAnimator;
    public Renderer bossRenderer;
    public NavMeshAgent navAgent;
    public GameObject swordObject;

    [Header("Phase 1 - Projectile & Slam")]
    public GameObject phase1Projectile;
    public Transform projectileSpawnPoint;
    public float phase1ProjectileSpeed = 18f;
    public float phase1ProjectileSize = 2.5f;
    public float phase1ShootInterval = 3f;
    public float phase1AscendHeight = 25f;
    public float phase1AscendSpeed = 12f;
    public float phase1DescendSpeed = 30f;
    public float phase1ShadowChaseSpeed = 8f;
    public float phase1InAirDuration = 4f;
    public float phase1SlamRadius = 3.5f;
    public float phase1SlamDamage = 40f;
    public float phase1ShotDamage = 25f;
    public LayerMask playerLayer;
    private bool phase1InAir = false;
    private bool phase1CanShoot = true;
    private Vector3 phase1ShadowTargetPos;
    private float phase1ShootTimer = 0f;
    private float phase1InAirTimer = 0f;
    private Vector3 phase1AirPosition;
    private bool phase1Descending = false;

    [Header("Phase 2 - Dash & Stun")]
    public float phase2DashSpeed = 35f;
    public float phase2DashDistance = 12f;
    public float phase2StunDuration = 2.2f;
    public float phase2TimeBetweenDashes = 1.8f;
    public float phase2DashDamage = 30f;
    public float phase2ScaleMultiplier = 0.55f;
    private bool phase2IsStunned = false;
    private bool phase2IsDashing = false;
    private bool phase2WaitingForNextDash = false;
    private float phase2StunTimer = 0f;
    private float phase2DashCooldownTimer = 0f;
    private int phase2DashCount = 0;
    private int phase2DashesBeforeStun = 3;
    private Vector3 phase2DashDirection;
    private Vector3 phase2DashStartPos;
    private Vector3 phase2DashEndPos;
    private float phase2DashProgress = 0f;

    [Header("Phase 3 - Combo Attack")]
    public GameObject phase3Projectile;
    public GameObject bombPrefab;
    public float phase3ProjectileSpeed = 22f;
    public float phase3ProjectileDamage = 20f;
    public float phase3BombDamage = 50f;
    public float phase3BombRadius = 5f;
    public float phase3BombFuseTime = 2f;
    public float phase3SwordDamage = 45f;
    public float phase3SwordRange = 2.5f;
    public float phase3DashApproachSpeed = 20f;
    public float phase3DashApproachStopDistance = 4f;
    public int maxBombsOnField = 4;
    public float phase3AttackCycleInterval = 1.2f;
    private float phase3AttackTimer = 0f;
    private int phase3AttackIndex = 0;
    private bool phase3IsDashApproaching = false;
    private bool phase3CanAttack = true;
    private List<GameObject> activeBombs = new List<GameObject>();
    private Vector3 phase3DashApproachTarget;
    private float phase3DashApproachProgress = 0f;
    private Vector3 phase3DashApproachStart;
    private bool phase3DashApproachMoving = false;

    [Header("Visual Effects")]
    public GameObject slamImpactEffect;
    public GameObject phaseTransitionEffect;
    public GameObject stunEffect;
    public GameObject dashTrailEffect;
    public Material phase1Material;
    public Material phase2Material;
    public Material phase3Material;
    public GameObject shadowTrail;

    [Header("Audio")]
    public AudioClip shootSound;
    public AudioClip slamSound;
    public AudioClip dashSound;
    public AudioClip stunnedSound;
    public AudioClip swordSwingSound;
    public AudioClip bombPlaceSound;
    public AudioClip phaseTransitionSound;
    public AudioClip deathSound;
    private AudioSource audioSource;

    private void Awake()
    {
        currentHealth = maxHealth;
        audioSource = GetComponent<AudioSource>();
        if (navAgent == null)
            navAgent = GetComponent<NavMeshAgent>();
        if (bossCollider == null)
            bossCollider = GetComponent<Collider>();
        if (bossRenderer == null)
            bossRenderer = GetComponentInChildren<Renderer>();
        if (shadowObject != null)
            shadowObject.SetActive(false);
        if (swordObject != null)
            swordObject.SetActive(false);
    }

    private void Start()
    {
        if (player == null)
            player = GameObject.FindGameObjectWithTag("Player").transform;

        StartPhase1();
    }

    private void Update()
    {
        if (isDead || isTransitioning) return;

        CheckPhaseTransitions();

        switch (currentPhase)
        {
            case BossPhase.Phase1:
                HandlePhase1();
                break;
            case BossPhase.Phase2:
                HandlePhase2();
                break;
            case BossPhase.Phase3:
                HandlePhase3();
                break;
        }
    }

    private void CheckPhaseTransitions()
    {
        if (currentPhase == BossPhase.Phase1 && currentHealth <= phase2HealthThreshold)
        {
            StartCoroutine(TransitionToPhase2());
        }
        else if (currentPhase == BossPhase.Phase2 && currentHealth <= phase3HealthThreshold)
        {
            StartCoroutine(TransitionToPhase3());
        }
    }

    public void TakeDamage(float amount)
    {
        if (isDead) return;

        if (currentPhase == BossPhase.Phase2 && !phase2IsStunned)
            return;

        currentHealth -= amount;
        currentHealth = Mathf.Clamp(currentHealth, 0, maxHealth);

        if (currentHealth <= 0)
        {
            StartCoroutine(Die());
        }
    }

    private IEnumerator Die()
    {
        isDead = true;
        if (navAgent != null && navAgent.isActiveAndEnabled)
            navAgent.isStopped = true;

        if (bossAnimator != null)
            bossAnimator.SetTrigger("Die");

        if (deathSound != null)
            audioSource.PlayOneShot(deathSound);

        if (phaseTransitionEffect != null)
        {
            GameObject fx = Instantiate(phaseTransitionEffect, transform.position, Quaternion.identity);
            Destroy(fx, 4f);
        }

        foreach (GameObject bomb in activeBombs)
        {
            if (bomb != null) Destroy(bomb);
        }
        activeBombs.Clear();

        yield return new WaitForSeconds(2f);
        Destroy(gameObject);
    }

    private void StartPhase1()
    {
        currentPhase = BossPhase.Phase1;
        phase1InAir = false;
        phase1CanShoot = true;
        phase1ShootTimer = 0f;

        if (bossRenderer != null && phase1Material != null)
            bossRenderer.material = phase1Material;

        if (navAgent != null)
        {
            navAgent.enabled = true;
            navAgent.isStopped = false;
            navAgent.speed = 5f;
        }

        transform.localScale = Vector3.one;

        if (shadowObject != null)
            shadowObject.SetActive(false);

        if (swordObject != null)
            swordObject.SetActive(false);
    }

    private void HandlePhase1()
    {
        if (!phase1InAir)
        {
            phase1ShootTimer += Time.deltaTime;

            if (navAgent != null && navAgent.isActiveAndEnabled)
            {
                navAgent.SetDestination(player.position);
            }

            FacePlayer();

            if (phase1ShootTimer >= phase1ShootInterval && phase1CanShoot)
            {
                phase1ShootTimer = 0f;
                StartCoroutine(Phase1ShootThenAscend());
            }
        }
        else
        {
            if (phase1Descending)
            {
                Phase1DescendOnPlayer();
            }
            else
            {
                phase1InAirTimer += Time.deltaTime;

                Vector3 shadowTarget = player.position;
                shadowTarget.y = player.position.y;

                if (shadowObject != null)
                {
                    shadowObject.transform.position = Vector3.MoveTowards(
                        shadowObject.transform.position,
                        shadowTarget,
                        phase1ShadowChaseSpeed * Time.deltaTime
                    );
                }

                if (phase1InAirTimer >= phase1InAirDuration)
                {
                    phase1Descending = true;
                    phase1InAirTimer = 0f;
                    if (shadowObject != null)
                        phase1ShadowTargetPos = shadowObject.transform.position;
                }
            }
        }
    }

    private IEnumerator Phase1ShootThenAscend()
    {
        phase1CanShoot = false;
        phase1InAir = true;

        if (navAgent != null)
            navAgent.isStopped = true;

        if (bossAnimator != null)
            bossAnimator.SetTrigger("Shoot");

        ShootPhase1Projectile();

        yield return new WaitForSeconds(0.6f);

        if (bossAnimator != null)
            bossAnimator.SetTrigger("Ascend");

        float elapsed = 0f;
        Vector3 startPos = transform.position;
        Vector3 targetPos = new Vector3(transform.position.x, transform.position.y + phase1AscendHeight, transform.position.z);

        while (elapsed < 1f)
        {
            elapsed += Time.deltaTime * (phase1AscendSpeed / phase1AscendHeight);
            transform.position = Vector3.Lerp(startPos, targetPos, elapsed);
            yield return null;
        }

        transform.position = targetPos;
        phase1AirPosition = targetPos;

        bossRenderer.enabled = false;

        if (shadowObject != null)
        {
            shadowObject.SetActive(true);
            shadowObject.transform.position = new Vector3(transform.position.x, player.position.y + 0.1f, transform.position.z);
        }

        phase1InAirTimer = 0f;
        phase1Descending = false;
    }

    private void Phase1DescendOnPlayer()
    {
        Vector3 descendTarget = new Vector3(phase1ShadowTargetPos.x, player.position.y, phase1ShadowTargetPos.z);

        transform.position = Vector3.MoveTowards(
            transform.position,
            new Vector3(phase1ShadowTargetPos.x, transform.position.y, phase1ShadowTargetPos.z),
            phase1DescendSpeed * Time.deltaTime * 0.5f
        );

        transform.position = new Vector3(transform.position.x,
            Mathf.MoveTowards(transform.position.y, player.position.y, phase1DescendSpeed * Time.deltaTime),
            transform.position.z);

        if (Vector3.Distance(transform.position, descendTarget) < 0.5f)
        {
            transform.position = descendTarget;
            bossRenderer.enabled = true;

            if (shadowObject != null)
                shadowObject.SetActive(false);

            if (slamImpactEffect != null)
            {
                GameObject fx = Instantiate(slamImpactEffect, transform.position, Quaternion.identity);
                Destroy(fx, 2f);
            }

            if (slamSound != null)
                audioSource.PlayOneShot(slamSound);

            Collider[] hit = Physics.OverlapSphere(transform.position, phase1SlamRadius, playerLayer);
            foreach (Collider c in hit)
            {
                PlayerHealth ph = c.GetComponent<PlayerHealth>();
                if (ph != null)
                    ph.TakeDamage(phase1SlamDamage);
            }

            if (navAgent != null)
            {
                navAgent.Warp(transform.position);
                navAgent.isStopped = false;
            }

            phase1InAir = false;
            phase1Descending = false;
            phase1CanShoot = true;
            phase1ShootTimer = 0f;
        }
    }

    private void ShootPhase1Projectile()
    {
        if (phase3Projectile == null && phase1Projectile == null) return;

        GameObject proj = Instantiate(phase1Projectile, projectileSpawnPoint.position, Quaternion.identity);
        proj.transform.localScale = Vector3.one * phase1ProjectileSize;

        Vector3 dir = (player.position - projectileSpawnPoint.position).normalized;
        Rigidbody rb = proj.GetComponent<Rigidbody>();
        if (rb != null)
            rb.linearVelocity = dir * phase1ProjectileSpeed;

        BossProjectile bpComp = proj.GetComponent<BossProjectile>();
        if (bpComp != null)
            bpComp.damage = phase1ShotDamage;

        if (shootSound != null)
            audioSource.PlayOneShot(shootSound);

        Destroy(proj, 8f);
    }

    private IEnumerator TransitionToPhase2()
    {
        if (isTransitioning) yield break;
        isTransitioning = true;

        phase1InAir = false;
        phase1Descending = false;

        if (navAgent != null)
            navAgent.isStopped = true;

        if (bossAnimator != null)
            bossAnimator.SetTrigger("PhaseTransition");

        if (phaseTransitionEffect != null)
        {
            GameObject fx = Instantiate(phaseTransitionEffect, transform.position, Quaternion.identity);
            Destroy(fx, 3f);
        }

        if (phaseTransitionSound != null)
            audioSource.PlayOneShot(phaseTransitionSound);

        bossRenderer.enabled = true;

        if (shadowObject != null)
            shadowObject.SetActive(false);

        yield return new WaitForSeconds(2f);

        Vector3 originalScale = Vector3.one;
        Vector3 targetScale = Vector3.one * phase2ScaleMultiplier;
        float scaleElapsed = 0f;

        while (scaleElapsed < 1f)
        {
            scaleElapsed += Time.deltaTime * 2f;
            transform.localScale = Vector3.Lerp(originalScale, targetScale, scaleElapsed);
            yield return null;
        }

        transform.localScale = targetScale;

        if (bossRenderer != null && phase2Material != null)
            bossRenderer.material = phase2Material;

        currentPhase = BossPhase.Phase2;
        isTransitioning = false;

        StartPhase2();
    }

    private void StartPhase2()
    {
        phase2IsStunned = false;
        phase2IsDashing = false;
        phase2WaitingForNextDash = false;
        phase2StunTimer = 0f;
        phase2DashCooldownTimer = 0f;
        phase2DashCount = 0;
        phase2DashesBeforeStun = Random.Range(2, 5);

        if (navAgent != null)
        {
            navAgent.enabled = false;
        }

        if (bossCollider != null)
            bossCollider.enabled = true;
    }

    private void HandlePhase2()
    {
        if (phase2IsStunned)
        {
            phase2StunTimer += Time.deltaTime;

            if (stunEffect != null)
                stunEffect.SetActive(true);

            if (phase2StunTimer >= phase2StunDuration)
            {
                phase2IsStunned = false;
                phase2StunTimer = 0f;
                phase2DashCount = 0;
                phase2DashesBeforeStun = Random.Range(2, 5);

                if (stunEffect != null)
                    stunEffect.SetActive(false);

                phase2WaitingForNextDash = true;
                phase2DashCooldownTimer = 0f;
            }

            return;
        }

        if (phase2IsDashing)
        {
            phase2DashProgress += Time.deltaTime * (phase2DashSpeed / phase2DashDistance);
            transform.position = Vector3.Lerp(phase2DashStartPos, phase2DashEndPos, phase2DashProgress);

            if (phase2DashProgress >= 1f)
            {
                transform.position = phase2DashEndPos;
                phase2IsDashing = false;
                phase2DashCount++;

                CheckDashPlayerHit();

                if (dashTrailEffect != null)
                    dashTrailEffect.SetActive(false);

                if (phase2DashCount >= phase2DashesBeforeStun)
                {
                    phase2IsStunned = true;
                    phase2StunTimer = 0f;

                    if (stunnedSound != null)
                        audioSource.PlayOneShot(stunnedSound);

                    if (bossAnimator != null)
                        bossAnimator.SetTrigger("Stunned");
                }
                else
                {
                    phase2WaitingForNextDash = true;
                    phase2DashCooldownTimer = 0f;
                }
            }

            return;
        }

        if (phase2WaitingForNextDash)
        {
            phase2DashCooldownTimer += Time.deltaTime;

            FacePlayer();

            if (phase2DashCooldownTimer >= phase2TimeBetweenDashes)
            {
                phase2WaitingForNextDash = false;
                StartPhase2Dash();
            }

            return;
        }

        FacePlayer();
        phase2WaitingForNextDash = true;
        phase2DashCooldownTimer = 0f;
    }

    private void StartPhase2Dash()
    {
        phase2IsDashing = true;
        phase2DashProgress = 0f;
        phase2DashStartPos = transform.position;

        Vector3 dashDir = (player.position - transform.position).normalized;
        phase2DashDirection = dashDir;
        phase2DashEndPos = transform.position + dashDir * phase2DashDistance;

        if (dashSound != null)
            audioSource.PlayOneShot(dashSound);

        if (bossAnimator != null)
            bossAnimator.SetTrigger("Dash");

        if (dashTrailEffect != null)
            dashTrailEffect.SetActive(true);
    }

    private void CheckDashPlayerHit()
    {
        Collider[] hits = Physics.OverlapSphere(transform.position, 1.5f * phase2ScaleMultiplier + 0.5f, playerLayer);
        foreach (Collider c in hits)
        {
            PlayerHealth ph = c.GetComponent<PlayerHealth>();
            if (ph != null)
                ph.TakeDamage(phase2DashDamage);
        }
    }

    private IEnumerator TransitionToPhase3()
    {
        if (isTransitioning) yield break;
        isTransitioning = true;

        phase2IsDashing = false;
        phase2IsStunned = false;
        phase2WaitingForNextDash = false;

        if (stunEffect != null)
            stunEffect.SetActive(false);

        if (bossAnimator != null)
            bossAnimator.SetTrigger("PhaseTransition");

        if (phaseTransitionEffect != null)
        {
            GameObject fx = Instantiate(phaseTransitionEffect, transform.position, Quaternion.identity);
            Destroy(fx, 3f);
        }

        if (phaseTransitionSound != null)
            audioSource.PlayOneShot(phaseTransitionSound);

        yield return new WaitForSeconds(2f);

        Vector3 originalScale = transform.localScale;
        Vector3 targetScale = Vector3.one * 1.3f;
        float scaleElapsed = 0f;

        while (scaleElapsed < 1f)
        {
            scaleElapsed += Time.deltaTime * 1.5f;
            transform.localScale = Vector3.Lerp(originalScale, targetScale, scaleElapsed);
            yield return null;
        }

        transform.localScale = targetScale;

        if (bossRenderer != null && phase3Material != null)
            bossRenderer.material = phase3Material;

        if (navAgent != null)
        {
            navAgent.enabled = true;
            navAgent.isStopped = false;
            navAgent.speed = 6f;
        }

        if (swordObject != null)
            swordObject.SetActive(true);

        currentPhase = BossPhase.Phase3;
        isTransitioning = false;

        StartPhase3();
    }

    private void StartPhase3()
    {
        phase3AttackTimer = 0f;
        phase3AttackIndex = 0;
        phase3CanAttack = true;
        phase3IsDashApproaching = false;
        phase3DashApproachMoving = false;
        activeBombs.Clear();
    }

    private void HandlePhase3()
    {
        if (phase3IsDashApproaching)
        {
            HandlePhase3DashApproach();
            return;
        }

        if (!phase3CanAttack) return;

        if (navAgent != null && navAgent.isActiveAndEnabled)
        {
            float distToPlayer = Vector3.Distance(transform.position, player.position);
            if (distToPlayer > phase3DashApproachStopDistance + 2f)
                navAgent.SetDestination(player.position);
            else
                navAgent.SetDestination(transform.position);
        }

        FacePlayer();

        phase3AttackTimer += Time.deltaTime;

        if (phase3AttackTimer >= phase3AttackCycleInterval)
        {
            phase3AttackTimer = 0f;
            ExecutePhase3Attack();
        }
    }

    private void ExecutePhase3Attack()
    {
        int attackChoice = phase3AttackIndex % 5;
        phase3AttackIndex++;

        switch (attackChoice)
        {
            case 0:
                StartCoroutine(Phase3SwordAttack());
                break;
            case 1:
                Phase3ShootProjectiles();
                break;
            case 2:
                StartCoroutine(Phase3PlaceBomb());
                break;
            case 3:
                Phase3DashApproach();
                break;
            case 4:
                StartCoroutine(Phase3ComboAttack());
                break;
        }
    }

    private IEnumerator Phase3SwordAttack()
    {
        phase3CanAttack = false;

        if (navAgent != null)
            navAgent.isStopped = true;

        if (bossAnimator != null)
            bossAnimator.SetTrigger("SwordAttack");

        if (swordSwingSound != null)
            audioSource.PlayOneShot(swordSwingSound);

        yield return new WaitForSeconds(0.35f);

        float distToPlayer = Vector3.Distance(transform.position, player.position);
        if (distToPlayer <= phase3SwordRange)
        {
            PlayerHealth ph = player.GetComponent<PlayerHealth>();
            if (ph != null)
                ph.TakeDamage(phase3SwordDamage);
        }

        yield return new WaitForSeconds(0.4f);

        if (navAgent != null)
            navAgent.isStopped = false;

        phase3CanAttack = true;
    }

    private void Phase3ShootProjectiles()
    {
        if (phase3Projectile == null) return;

        StartCoroutine(Phase3ShootBurst());
    }

    private IEnumerator Phase3ShootBurst()
    {
        phase3CanAttack = false;

        int shotCount = 3;
        for (int i = 0; i < shotCount; i++)
        {
            if (projectileSpawnPoint == null) break;

            GameObject proj = Instantiate(phase3Projectile, projectileSpawnPoint.position, Quaternion.identity);

            Vector3 dir = (player.position - projectileSpawnPoint.position).normalized;
            float spread = (i - 1) * 10f;
            dir = Quaternion.Euler(0, spread, 0) * dir;

            Rigidbody rb = proj.GetComponent<Rigidbody>();
            if (rb != null)
                rb.linearVelocity = dir * phase3ProjectileSpeed;

            BossProjectile bpComp = proj.GetComponent<BossProjectile>();
            if (bpComp != null)
                bpComp.damage = phase3ProjectileDamage;

            if (shootSound != null)
                audioSource.PlayOneShot(shootSound);

            Destroy(proj, 8f);

            yield return new WaitForSeconds(0.18f);
        }

        yield return new WaitForSeconds(0.3f);
        phase3CanAttack = true;
    }

    private IEnumerator Phase3PlaceBomb()
    {
        phase3CanAttack = false;

        if (activeBombs.Count >= maxBombsOnField)
        {
            if (activeBombs[0] != null)
                Destroy(activeBombs[0]);
            activeBombs.RemoveAt(0);
        }

        if (bossAnimator != null)
            bossAnimator.SetTrigger("PlaceBomb");

        if (bombPlaceSound != null)
            audioSource.PlayOneShot(bombPlaceSound);

        yield return new WaitForSeconds(0.3f);

        if (bombPrefab != null)
        {
            Vector3 bombPos = transform.position + transform.forward * 1.5f;
            bombPos.y = transform.position.y;

            GameObject bomb = Instantiate(bombPrefab, bombPos, Quaternion.identity);
            activeBombs.Add(bomb);

            BossBomb bombComp = bomb.GetComponent<BossBomb>();
            if (bombComp == null)
                bombComp = bomb.AddComponent<BossBomb>();

            bombComp.Initialize(phase3BombDamage, phase3BombRadius, phase3BombFuseTime, playerLayer, this);

            StartCoroutine(RemoveBombFromListAfterFuse(bomb, phase3BombFuseTime + 0.5f));
        }

        yield return new WaitForSeconds(0.4f);
        phase3CanAttack = true;
    }

    private IEnumerator RemoveBombFromListAfterFuse(GameObject bomb, float delay)
    {
        yield return new WaitForSeconds(delay);
        activeBombs.Remove(bomb);
    }

    private void Phase3DashApproach()
    {
        if (phase3DashApproachMoving) return;

        float distToPlayer = Vector3.Distance(transform.position, player.position);
        if (distToPlayer <= phase3DashApproachStopDistance + 1f) return;

        phase3IsDashApproaching = true;
        phase3DashApproachMoving = true;
        phase3DashApproachProgress = 0f;
        phase3DashApproachStart = transform.position;

        Vector3 dirToPlayer = (player.position - transform.position).normalized;
        phase3DashApproachTarget = player.position - dirToPlayer * phase3DashApproachStopDistance;
        phase3DashApproachTarget.y = transform.position.y;

        if (navAgent != null)
            navAgent.isStopped = true;

        if (dashSound != null)
            audioSource.PlayOneShot(dashSound);

        if (bossAnimator != null)
            bossAnimator.SetTrigger("DashApproach");

        if (dashTrailEffect != null)
            dashTrailEffect.SetActive(true);
    }

    private void HandlePhase3DashApproach()
    {
        float totalDist = Vector3.Distance(phase3DashApproachStart, phase3DashApproachTarget);
        if (totalDist < 0.01f)
        {
            FinishPhase3DashApproach();
            return;
        }

        phase3DashApproachProgress += Time.deltaTime * (phase3DashApproachSpeed / totalDist);
        transform.position = Vector3.Lerp(phase3DashApproachStart, phase3DashApproachTarget, phase3DashApproachProgress);

        FacePlayer();

        if (phase3DashApproachProgress >= 1f)
        {
            transform.position = phase3DashApproachTarget;
            FinishPhase3DashApproach();
        }
    }

    private void FinishPhase3DashApproach()
    {
        phase3IsDashApproaching = false;
        phase3DashApproachMoving = false;

        if (dashTrailEffect != null)
            dashTrailEffect.SetActive(false);

        if (navAgent != null)
        {
            navAgent.Warp(transform.position);
            navAgent.isStopped = false;
        }

        phase3CanAttack = true;
    }

    private IEnumerator Phase3ComboAttack()
    {
        phase3CanAttack = false;

        if (navAgent != null)
            navAgent.isStopped = true;

        Phase3ShootProjectiles();
        yield return new WaitForSeconds(0.5f);

        yield return StartCoroutine(Phase3SwordAttack());

        yield return new WaitForSeconds(0.3f);

        Phase3DashApproach();

        yield return new WaitForSeconds(0.6f);

        if (navAgent != null)
            navAgent.isStopped = false;

        phase3CanAttack = true;
    }

    private void FacePlayer()
    {
        if (player == null) return;

        Vector3 dir = player.position - transform.position;
        dir.y = 0f;

        if (dir.sqrMagnitude > 0.001f)
        {
            Quaternion targetRot = Quaternion.LookRotation(dir);
            transform.rotation = Quaternion.Slerp(transform.rotation, targetRot, Time.deltaTime * 8f);
        }
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, phase1SlamRadius);

        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(transform.position, phase3SwordRange);

        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(transform.position, phase3BombRadius);

        Gizmos.color = Color.cyan;
        Gizmos.DrawWireSphere(transform.position, phase3DashApproachStopDistance);
    }
}

public class BossProjectile : MonoBehaviour
{
    public float damage = 20f;
    public LayerMask playerLayer;

    private void OnTriggerEnter(Collider other)
    {
        PlayerHealth ph = other.GetComponent<PlayerHealth>();
        if (ph != null)
        {
            ph.TakeDamage(damage);
            Destroy(gameObject);
        }
        else if (!other.isTrigger)
        {
            Destroy(gameObject);
        }
    }
}

public class BossBomb : MonoBehaviour
{
    private float damage;
    private float radius;
    private float fuseTime;
    private LayerMask playerLayer;
    private FinalBoss owner;
    private float timer = 0f;
    private bool hasExploded = false;
    private Renderer bombRenderer;
    private Light bombLight;

    public void Initialize(float dmg, float rad, float fuse, LayerMask layer, FinalBoss boss)
    {
        damage = dmg;
        radius = rad;
        fuseTime = fuse;
        playerLayer = layer;
        owner = boss;
        timer = 0f;

        bombRenderer = GetComponentInChildren<Renderer>();
        bombLight = GetComponentInChildren<Light>();
    }

    private void Update()
    {
        if (hasExploded) return;

        timer += Time.deltaTime;

        float blinkRate = Mathf.Lerp(1f, 12f, timer / fuseTime);
        bool blinkOn = Mathf.Sin(Time.time * blinkRate * Mathf.PI) > 0f;

        if (bombRenderer != null)
            bombRenderer.enabled = blinkOn;

        if (bombLight != null)
            bombLight.enabled = blinkOn;

        if (timer >= fuseTime)
        {
            Explode();
        }
    }

    private void Explode()
    {
        if (hasExploded) return;
        hasExploded = true;

        Collider[] hits = Physics.OverlapSphere(transform.position, radius, playerLayer);
        foreach (Collider c in hits)
        {
            PlayerHealth ph = c.GetComponent<PlayerHealth>();
            if (ph != null)
                ph.TakeDamage(damage);
        }

        Destroy(gameObject);
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, radius);
    }
}

public class PlayerHealth : MonoBehaviour
{
    public float maxHealth = 100f;
    private float currentHealth;

    private void Start()
    {
        currentHealth = maxHealth;
    }

    public void TakeDamage(float amount)
    {
        currentHealth -= amount;
        currentHealth = Mathf.Clamp(currentHealth, 0, maxHealth);

        if (currentHealth <= 0)
        {
            Die();
        }
    }

    public void Heal(float amount)
    {
        currentHealth += amount;
        currentHealth = Mathf.Clamp(currentHealth, 0, maxHealth);
    }

    public float GetHealthPercent()
    {
        return currentHealth / maxHealth;
    }

    private void Die()
    {
        Debug.Log("Player died!");
    }
}