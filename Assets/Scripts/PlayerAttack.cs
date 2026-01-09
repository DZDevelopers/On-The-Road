using UnityEngine;

public class PlayerAttack : MonoBehaviour
{
    private PlayerMovement _PM;
    [SerializeField] private string attackButton = "Fire2";
    private Animator anime;
    [SerializeField] private GameObject Player;
    [SerializeField] private GameObject bullet;
    private bool isShooting;
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
        shootingTimer();
    }
    void Shoot()
    {
        if (!isShooting)
        {
            if (_PM.facingDirection == Vector2.down)
            {
                anime.Play("Player_RangeAttack_DOWN");
                GameObject b = Instantiate(bullet,new Vector2 (Player.transform.position.x,Player.transform.position.y - 1),Quaternion.Euler(bullet.transform.rotation.x, bullet.transform.rotation.y, 180));
                shootingTime = 0f;
                b.GetComponent<Bullet>().SetDirection(Vector2.down);
            }
            if (_PM.facingDirection == Vector2.up)
            {
                anime.Play("Player_RangeAttack_UP");
                GameObject b = Instantiate(bullet,new Vector2 (Player.transform.position.x,Player.transform.position.y + 1),Quaternion.Euler(bullet.transform.rotation.x, bullet.transform.rotation.y, 0));
                shootingTime = 0f;
                b.GetComponent<Bullet>().SetDirection(Vector2.up);
            }
            if (_PM.facingDirection == Vector2.right)
            {
                anime.Play("Player_RangeAttack_RIGHT");
                GameObject b = Instantiate(bullet,new Vector2 (Player.transform.position.x + 1 ,Player.transform.position.y),Quaternion.Euler(bullet.transform.rotation.x, bullet.transform.rotation.y, 270));
                shootingTime = 0f;
                b.GetComponent<Bullet>().SetDirection(Vector2.right);
            }
            if (_PM.facingDirection == Vector2.left)
            {
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
}