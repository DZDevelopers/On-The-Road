using UnityEngine;

public class Fly : MonoBehaviour
{

    [SerializeField] private float chargeSpeed = 10f;
    [SerializeField] private float chargeDuration = 0.6f;
    [SerializeField] private float detectionRange = 6f;
    private Rigidbody2D _rb;
    [SerializeField] private Transform player;
    private bool isCharging = false;
    private Vector2 chargeDirection;
    private float chargeTimer;
    [HideInInspector] public Vector2 facingDirection = Vector2.right;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _rb = GetComponent<Rigidbody2D>();
        player = GameObject.FindGameObjectWithTag("Player").transform;
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
    }
    void FixedUpdate()
    {
        _rb.linearVelocity = chargeDirection * chargeSpeed;
    }
     void DetectPlayer()
    {
        float distance = Vector2.Distance(transform.position, player.position);

        if (distance <= detectionRange)
        {
            StartCharge();
        }
    }

    void StartCharge()
    {
        isCharging = true;
        chargeTimer = chargeDuration;
        chargeDirection = (player.position - transform.position).normalized;
    }

    void StopCharge()
    {
        isCharging = false;
        _rb.linearVelocity = Vector2.zero;
    }
}
