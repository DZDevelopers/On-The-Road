using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerAttack : MonoBehaviour
{
    private PlayerMovement _PM;
    [SerializeField] private string attackButton = "Fire2";
    private Animator anime;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _PM = GetComponent<PlayerMovement>();
        anime = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown(attackButton))
        {
            Shoot();
        }
    }
    void Shoot()
    {
         if (_PM.facingDirection == Vector2.down)
        {
            anime.Play("Player_RangeAttack_DOWN");
        }
        if (_PM.facingDirection == Vector2.up)
        {
            anime.Play("Player_RangeAttack_UP");
        }
        if (_PM.facingDirection == Vector2.right)
        {
            anime.Play("Player_RangeAttack_RIGHT");
        }
        if (_PM.facingDirection == Vector2.left)
        {
            anime.Play("Player_RangeAttack_LEFT");
        }
    }
}