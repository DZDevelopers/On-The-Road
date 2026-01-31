using UnityEngine;

public class Fly : MonoBehaviour
{
    public PlayerHealth playerHealth;
    [SerializeField] private float chargeSpeed = 10f;
    [SerializeField] private float chargeDuration = 0.6f;
    [SerializeField] private float detectionRange = 6f;
    private Rigidbody2D _rb;
    private Transform player;
    private bool isCharging = false;
    private Vector2 chargeDirection;
    private float chargeTimer;
    private bool OnColdown;
    private float CT;
    public float coldowntimer = 1f;
    [HideInInspector] public Vector2 facingDirection = Vector2.right;
    public PlayerAttack playerAttack;
    private Animator anime;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _rb = GetComponent<Rigidbody2D>();
        player = GameObject.FindGameObjectWithTag("Player").transform;
        anime = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        if (isCharging)
        {
            chargeTimer -= Time.deltaTime;
            if (chargeTimer <= 0f)
            {
                StopCharge();
            }
        }
        else
        {
            DetectPlayer();
        }
        if (chargeDirection.x < 0)
        {
            transform.localScale = new Vector3(1f, 1f, 1f);
        }   
        if (chargeDirection.x > 0)
        {
            transform.localScale = new Vector3(-1f, 1f, 1f);  
        }
        if (CT > 0)
        {
            OnColdown = true;
        }
        if (CT < 0)
        {
            OnColdown = false;
        }  
        CT -= Time.deltaTime;   
    }
    void FixedUpdate()
    {
        if (isCharging)
        {
            _rb.linearVelocity = chargeDirection * chargeSpeed;
        }
    }
    void DetectPlayer()
    {
        float distance = Vector2.Distance(transform.position, player.position);

        if (!OnColdown)
        {
            if (distance <= detectionRange)
            {
                StartCharge();
            }
        }
        
    }

    void StartCharge()
    {
        isCharging = true;
        chargeTimer = chargeDuration;
        chargeDirection = (player.position - transform.position).normalized;
        Coldown();
    }

    void StopCharge()
    {
        isCharging = false;
        _rb.linearVelocity = Vector2.zero;
    }
    void Coldown()
    {
        CT = coldowntimer;
    }
    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
           playerHealth.TakeDamage(1);
        }
        if (collision.gameObject.tag == "Bullet")
        {
            Destroy(collision.gameObject);
            EDeath();
        }
    }
    void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "AttackPoint")
        {
            EDeath();
        }
    }
    void EDeath()
    {
        anime.Play("Fly_Death");
        Destroy(gameObject, 0.1f);
        playerAttack.playerEXP += 10;
        playerAttack.AmmoAmount += 1;
        playerAttack.HealAmount += 1;
    }
}
