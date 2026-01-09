using UnityEngine;

public class Bullet : MonoBehaviour
{
    [SerializeField] float speed = 3f;
    [SerializeField] float lifeTime = 20f;
    Rigidbody2D _rb;

    void Awake()
    {
        _rb = GetComponent<Rigidbody2D>();
    }
    void Update()
    {
        lifeTime -= Time.deltaTime;
        if (lifeTime <= 0)
        {
            Destroy(gameObject);
        }
    }

    public void SetDirection(Vector2 dir)
    {
        _rb.linearVelocity = dir.normalized * speed;
    }
}
