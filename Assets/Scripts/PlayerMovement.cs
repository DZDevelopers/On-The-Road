using System;
using System.Runtime.CompilerServices;
using JetBrains.Annotations;
using UnityEditor.Callbacks;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    private Rigidbody2D _rb;
    private float MoveX;
    private float MoveY;
    [SerializeField] private float movespeed = 5f;
    public Sprite upSprite;
    public Sprite downSprite;
    public Sprite leftSprite;
    public Sprite rightSprite;
    private SpriteRenderer spriteRenderer;
    
    void Awake()
    {
        _rb = GetComponent<Rigidbody2D>();
        spriteRenderer = GetComponent<SpriteRenderer>();
    }
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        MoveX = Input.GetAxis("Horizontal");
        MoveY = Input.GetAxis("Vertical");
        if (MoveY > 0)
        {
            spriteRenderer.sprite = upSprite;
        }
        else if (MoveY < 0)
        {
            spriteRenderer.sprite = downSprite;
        }
        else if (MoveX < 0)
        {
            spriteRenderer.sprite = leftSprite;
        }
        else if (MoveX > 0)
        {
            spriteRenderer.sprite = rightSprite;
        }
    }
    void FixedUpdate()
    {
        _rb.linearVelocity = new Vector2 (MoveX * movespeed,MoveY * movespeed);
    }
}