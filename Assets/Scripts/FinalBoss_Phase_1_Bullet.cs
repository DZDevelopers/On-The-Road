using UnityEngine;

public class FinalBoss_Phase_1_Bullet : MonoBehaviour
{
    [SerializeField] float speed = 3f;
    [SerializeField] float lifeTime = 20f;
    [SerializeField] PlayerHealth playerHealth;
    Rigidbody2D _rb;
    private Animator anime;
    private Collider2D col;
    void Awake()
    {
        _rb = GetComponent<Rigidbody2D>();
        anime = GetComponent<Animator>();
        col = GetComponent<Collider2D>();
    }
    void Update()
    {
        lifeTime -= Time.deltaTime;
        if (lifeTime <= 0)
        {
            Destroy(gameObject);
        }
    }
    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            playerHealth.TakeDamage(2);
            _rb.linearVelocity = Vector2.zero;
            col.enabled = false;
            anime.Play("FinalBoss_Phase_1_Bullet_Hit");
        }
        if (collision.gameObject.tag == "Bullet")
        {
            Destroy(collision.gameObject);
        }
    }
    public void DestroyBullet()
    {
        Destroy(gameObject);
    }
}