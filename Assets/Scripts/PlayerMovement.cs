using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    private Rigidbody2D _rb;
    private BoxCollider2D boxCollider2D;
    private Animator animator;

    // Movement
    [SerializeField] private float moveSpeed = 5f;
    private float moveX;
    private float moveY;
    private Vector2 lastMoveDir = Vector2.down;

    // Combo / attack settings
    [SerializeField] private string attackButton = "Fire1";
    [SerializeField] private float attackDuration = 0.24f;    // how long each attack locks you
    [SerializeField] private float comboMaxDelay = 1f;     // time window to chain next attack
    [SerializeField] private float postComboCooldown = 0.5f; // cooldown after finishing 3 hits

    // State
    public bool isAttacking = false;
    private float attackTimer = 0f;  // current attack remaining time
    private float comboTimer = 0f;   // time left to press next attack to chain
    private float cooldownTimer = 0f;// global cooldown after full combo

    private int attacksPerformed = 0; // 0 = none, 1..3 = which hit was done in this combo
    private string currentAnim = "";
    [HideInInspector] public Vector2 facingDirection = Vector2.down;

    void Awake()
    {
        _rb = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
        boxCollider2D = GetComponent<BoxCollider2D>();
    }

    void Update()
    {
        if (cooldownTimer > 0f) cooldownTimer -= Time.deltaTime;
        moveX = Input.GetAxisRaw("Horizontal");
        moveY = Input.GetAxisRaw("Vertical");
        Vector2 moveDir = new Vector2(moveX, moveY);

        if (Input.GetButtonDown(attackButton))
        {
            if (!isAttacking && cooldownTimer <= 0f)
            {
                StartAttack();
            }
            // queue / chain next attack if within combo window and we haven't reached 3 hits
            else if (isAttacking && comboTimer > 0f && attacksPerformed < 3)
            {
                QueueNextAttack();
            }
        }

        // Timers while attacking
        if (isAttacking)
        {
            attackTimer -= Time.deltaTime;
            comboTimer -= Time.deltaTime;

            // Attack finished
            if (attackTimer <= 0f)
            {
                isAttacking = false;

                // If we just finished the 3rd attack, apply post-combo cooldown and reset combo counter
                if (attacksPerformed >= 3)
                {
                    // Start cooldown and reset combo so a new combo can't start until cooldown ends
                    cooldownTimer = postComboCooldown;
                    attacksPerformed = 0;
                    comboTimer = 0f;
                }
                else
                {
                    // if combo window expired, reset combo counter
                    if (comboTimer <= 0f)
                    {
                        attacksPerformed = 0;
                    }
                    // otherwise wait for the next input to chain
                }
            }
        }
        else
        {
            // Show walk/idle animations only when not attacking
            if (moveDir != Vector2.zero)
            {
                lastMoveDir = moveDir;
                PlayWalkAnimation(moveDir);
            }
            else
            {
                PlayIdleAnimation();
            }
        }
        if (moveDir != Vector2.zero)
        {
            facingDirection = moveDir.normalized;
        }
    }

    void FixedUpdate()
    {
        // Movement only applied if not attacking
        if (!isAttacking)
        {
            _rb.linearVelocity = new Vector2(moveX, moveY).normalized * moveSpeed;
        }
        else
        {
            _rb.linearVelocity = Vector2.zero;
        }
    }

    // Start a new combo (first attack)
    void StartAttack()
    {
        attacksPerformed = 1;
        isAttacking = true;
        attackTimer = attackDuration;
        comboTimer = comboMaxDelay;

        PlayAttackForCount(attacksPerformed);
    }

    // Called when player presses attack during the combo window
    void QueueNextAttack()
    {
        // Protect from going beyond 3 hits
        if (attacksPerformed >= 3) return;

        attacksPerformed++; // 1 -> 2 -> 3

        // If third attack was just triggered, disable further chaining (combo window cleared)
        if (attacksPerformed >= 3)
        {
            comboTimer = 0f; // no more chaining after hitting 3
        }
        else
        {
            // refresh combo window for chaining to the next step
            comboTimer = comboMaxDelay;
        }

        // Reset attack timer and mark attacking so FixedUpdate will block movement
        isAttacking = true;
        attackTimer = attackDuration;

        PlayAttackForCount(attacksPerformed);
    }

    // Play animation according to attacksPerformed (1 => original, 2 => mirrored clip, 3 => original again)
    void PlayAttackForCount(int count)
    {
        string animName = GetAttackAnimNameForDirection(count);
        PlayAnimation(animName);
    }

    // Determine the right animation name based on last movement direction and attack count
    string GetAttackAnimNameForDirection(int count)
    {
        // use _2 only for second attack, otherwise use _1 for 1st and 3rd
        string suffix = (count == 2) ? "_2" : "_1";

        if (Mathf.Abs(lastMoveDir.x) > Mathf.Abs(lastMoveDir.y))
        {
            if (lastMoveDir.x > 0) return "Attack_Right" + suffix;
            else return "Attack_Left" + suffix;
        }
        else
        {
            if (lastMoveDir.y > 0) return "Attack_Up" + suffix;
            else return "Attack_Down" + suffix;
        }
    }

    // Walk animations (4-direction)
    void PlayWalkAnimation(Vector2 dir)
    {
        if (Mathf.Abs(dir.x) > Mathf.Abs(dir.y))
        {
            if (dir.x > 0) PlayAnimation("Player_RIGHT");
            else PlayAnimation("Player_LEFT");
        }
        else
        {
            if (dir.y > 0) PlayAnimation("Player_UP");
            else PlayAnimation("Player_DOWN");
        }
    }

    // Idle animations based on last direction
    void PlayIdleAnimation()
    {
        if (Mathf.Abs(lastMoveDir.x) > Mathf.Abs(lastMoveDir.y))
        {
            if (lastMoveDir.x > 0) PlayAnimation("Player_IDLE_Right");
            else PlayAnimation("Player_IDLE_Left");
        }
        else
        {
            if (lastMoveDir.y > 0) PlayAnimation("Player_IDLE_Up");
            else PlayAnimation("Player_IDLE_Down");
        }
    }

    // Avoid replaying the same animation every frame
    void PlayAnimation(string anim)
    {
        if (currentAnim == anim) return;
        currentAnim = anim;

        if (animator != null)
            animator.Play(anim, 0);
    }
}
