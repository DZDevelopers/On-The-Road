using Unity.VisualScripting;
using UnityEngine;

public class PlayerAttack : MonoBehaviour
{
    [Header("Stuff That Actually Matter")]
    [SerializeField] public int AmmoAmount = 5;
    [SerializeField] public int AmmoMaxAmount = 5;
    [SerializeField] private string attackButton = "Fire2";
    [SerializeField] public int HealAmount = 15;
    [SerializeField] public int HealMaxAmount = 15;
    [SerializeField] private string healButton = "LeftShift";

    [Header("Stuff That Doesn't Matter")]
    private PlayerMovement _PM;
    private Animator anime;
    [SerializeField] private GameObject Player;
    [SerializeField] private GameObject bullet;
    public bool isShooting;
    private float shootingTime = 0.5f;
    
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
        if (Input.GetButtonDown(healButton))
        {
            Heal();
        }
        shootingTimer();
    }
    void Shoot()
    {
        if (!isShooting && AmmoAmount > 0)
        {
            if (_PM.facingDirection == Vector2.down)
            {
                AmmoAmount --;
                anime.Play("Player_RangeAttack_DOWN");
                GameObject b = Instantiate(bullet,new Vector2 (Player.transform.position.x,Player.transform.position.y - 1),Quaternion.Euler(bullet.transform.rotation.x, bullet.transform.rotation.y, 180));
                shootingTime = 0f;
                b.GetComponent<Bullet>().SetDirection(Vector2.down);
            }
            if (_PM.facingDirection == Vector2.up)
            {
                AmmoAmount --;
                anime.Play("Player_RangeAttack_UP");
                GameObject b = Instantiate(bullet,new Vector2 (Player.transform.position.x,Player.transform.position.y + 1),Quaternion.Euler(bullet.transform.rotation.x, bullet.transform.rotation.y, 0));
                shootingTime = 0f;
                b.GetComponent<Bullet>().SetDirection(Vector2.up);
            }
            if (_PM.facingDirection == Vector2.right)
            {
                AmmoAmount --;
                anime.Play("Player_RangeAttack_RIGHT");
                GameObject b = Instantiate(bullet,new Vector2 (Player.transform.position.x + 1 ,Player.transform.position.y),Quaternion.Euler(bullet.transform.rotation.x, bullet.transform.rotation.y, 270));
                shootingTime = 0f;
                b.GetComponent<Bullet>().SetDirection(Vector2.right);
            }
            if (_PM.facingDirection == Vector2.left)
            {
                AmmoAmount --;
                anime.Play("Player_RangeAttack_LEFT");
                GameObject b = Instantiate(bullet,new Vector2 (Player.transform.position.x - 1,Player.transform.position.y ),Quaternion.Euler(bullet.transform.rotation.x, bullet.transform.rotation.y, 90));
                shootingTime = 0f;
                b.GetComponent<Bullet>().SetDirection(Vector2.left);
            }
        }
    }
    void shootingTimer()
    {
        shootingTime += Time.deltaTime;
        if (shootingTime >= 0.5)
        {
            isShooting = false;
        }
        if (shootingTime <= 0.5)
        {
            isShooting = true;
        }
    }
    void Heal()
    {
        HealAmount -= 5;
        
    }

}