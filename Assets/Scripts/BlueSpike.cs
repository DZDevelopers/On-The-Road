using UnityEngine;
using UnityEngine.InputSystem;

public class BlueSpike : MonoBehaviour
{
    private BoxCollider2D boxCollider2D;
    public PlayerHealth playerHealth;
    public PlayerAttack playerAttack;
    [SerializeField] private PlayerMovement playerMovement;
    private Animator anime;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Awake()
    {
        boxCollider2D = GetComponent<BoxCollider2D>();
        anime = GetComponent<Animator>();
    }
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
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
        anime.Play("BlueEnemy_Death");
        Destroy(gameObject, 0.1f);
        playerAttack.playerEXP += 5;
    }
}