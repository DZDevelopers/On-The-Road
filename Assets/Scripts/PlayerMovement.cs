using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    private Rigidbody2D _rb;
    private Animator animator;

    private float moveX;
    private float moveY;

    [SerializeField] private float moveSpeed = 5f;
    [SerializeField] private string attackButton = "Fire1"; 
    [SerializeField] private float attackDuration = 0.3f; // Each hit duration
    [SerializeField] private float comboMaxDelay = 0.5f;   // Max time between attacks to continue combo

    private bool isAttacking = false;
    private float attackTimer = 0f;

    private int comboStep = 0; // 0,1,2 → attack index
    private float comboTimer = 0f;

    private Vector2 lastMoveDir = Vector2.down; 
    private string currentAnim;
    [SerializeField] private float postComboCooldown = 0.5f; // cooldown after full combo
    private float cooldownTimer = 0f;


    void Awake()
    {
        _rb = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
    }

    void Update()
    {
        // Movement input (only when not attacking)
        moveX = Input.GetAxisRaw("Horizontal");
        moveY = Input.GetAxisRaw("Vertical");

        Vector2 moveDir = new Vector2(moveX, moveY);
        if (!isAttacking)
        {
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
        if (cooldownTimer > 0f)
        {
            cooldownTimer -= Time.deltaTime;
        }
        
        // Attack input
        if (Input.GetButtonDown(attackButton))
        {
            if (!isAttacking && cooldownTimer <= 0f)
            {
                StartAttack();
            }
            else if (isAttacking && comboTimer > 0f)
            {
                // Queue next attack in combo
                QueueNextCombo();
            }
        }

        // Handle timers
        if (isAttacking)
        {
            attackTimer -= Time.deltaTime;
            comboTimer -= Time.deltaTime;

            if (attackTimer <= 0f)
            {
                isAttacking = false;

                // If combo timer still active, wait for next input
                if (comboTimer <= 0f)
                {
                    comboStep = 0; // Reset combo
                }
            }
        }
    }

    void FixedUpdate()
    {
        if (!isAttacking)
            _rb.linearVelocity = new Vector2(moveX, moveY).normalized * moveSpeed;
        else
            _rb.linearVelocity = Vector2.zero;
    }

    void StartAttack()
    {
        isAttacking = true;
        attackTimer = attackDuration;
        comboTimer = comboMaxDelay;

        PlayComboAnimation(comboStep);
    }

    void QueueNextCombo()
    {
        // Increment combo step (max 2, then loop)
        comboStep = (comboStep + 1) % 3;
        if (comboStep > 2)
        {
            comboStep = 0;
            cooldownTimer = postComboCooldown; // prevent immediate re-attack
        }
        isAttacking = true;
        attackTimer = attackDuration;
        comboTimer = comboMaxDelay;

        PlayComboAnimation(comboStep);
    }

    void PlayComboAnimation(int step)
    {
        string animName = "";

        if (Mathf.Abs(lastMoveDir.x) > Mathf.Abs(lastMoveDir.y))
        {
            if (lastMoveDir.x > 0)
                animName = $"Attack_Right_{step+1}";
            else
                animName = $"Attack_Left_{step+1}";
        }
        else
        {
            if (lastMoveDir.y > 0)
                animName = $"Attack_Up_{step+1}";
            else
                animName = $"Attack_Down_{step+1}";
        }

        PlayAnimation(animName);
    }

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

    void PlayAnimation(string anim)
    {
        if (currentAnim == anim) return;
        currentAnim = anim;
        animator.Play(anim, 0);
    }
}
