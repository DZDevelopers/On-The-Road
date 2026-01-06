using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    private Rigidbody2D _rb;
    private Animator animator;

    private float moveX;
    private float moveY;

    [SerializeField] private float moveSpeed = 5f;

    // Keeps track of last direction for idle animation
    private Vector2 lastMoveDir = Vector2.down;

    void Awake()
    {
        _rb = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
    }

    void Update()
    {
        moveX = Input.GetAxisRaw("Horizontal");
        moveY = Input.GetAxisRaw("Vertical");

        Vector2 moveDir = new Vector2(moveX, moveY);

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

    void FixedUpdate()
    {
        _rb.linearVelocity = new Vector2(moveX, moveY).normalized * moveSpeed;
    }

    void PlayWalkAnimation(Vector2 dir)
    {
        if (Mathf.Abs(dir.x) > Mathf.Abs(dir.y))
        {
            if (dir.x > 0)
                animator.Play("Player_LEFT");
            else
                animator.Play("Player_RIGHT");
        }
        else
        {
            if (dir.y > 0)
                animator.Play("Player_DOWN");
            else
                animator.Play("Player_UP");
        }
    }

    void PlayIdleAnimation()
    {
        if (Mathf.Abs(lastMoveDir.x) > Mathf.Abs(lastMoveDir.y))
        {
            if (lastMoveDir.x > 0)
                animator.Play("Player_IDLE_Right");
            else
                animator.Play("Player_IDLE_Left");
        }
        else
        {
            if (lastMoveDir.y > 0)
            {
                animator.Play("Player_IDLE_Down");
            }
            else
            {
                animator.Play("Player_IDLE_Up");
            }
        }
    }
}