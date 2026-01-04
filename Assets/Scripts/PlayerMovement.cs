using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    private Rigidbody2D _rb;
    private float MoveX;
    private float MoveY;
    [SerializeField] private float movespeed = 5f;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _rb = GetComponent<Rigidbody2D>();
    }

    // Update is called once per frame
    void Update()
    {
        MoveX = Input.GetAxis("Horizontal");
        MoveY = Input.GetAxis("Vertical");
    }
    void FixedUpdate()
    {
        _rb.linearVelocity = new Vector2 (MoveX * movespeed,MoveY * movespeed);
    }
}
