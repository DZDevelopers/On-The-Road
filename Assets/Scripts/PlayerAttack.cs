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
    [SerializeField] private float healingTime = 1f;
    [SerializeField] private float healingTimer = 1f;
    [SerializeField] private float healingCooldown = 1f;


    [Header("Stuff That Doesn't Matter")]
    private PlayerMovement _PM;
    private PlayerHealth _PH;
    private Animator anime;
    [SerializeField] private GameObject Player;
    [SerializeField] private GameObject bullet;
    public bool isShooting;
    public bool isHealing;
    private int SP = 0;
    private float shootingTime = 0.5f;
    public int playerEXP = 0;
    public bool HasALevelUp = false;
    public int playerLevel = 1;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _PM = GetComponent<PlayerMovement>();
        anime = GetComponent<Animator>();
        _PH = GetComponent<PlayerHealth>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown(attackButton))
        {
            Shoot();
        }
        if (Input.GetKey(KeyCode.LeftShift))
        {
            SP = 1;
            isHealing = true;
            Heal();
        }
        else
        {
            isHealing = false;
            anime.SetBool("IsHealing",false);
        }
        if (Input.GetKeyUp(KeyCode.LeftShift))
        {
            SP = 0;
        }
        ShootingTimer();
        HealingTimer();
        healingCooldown -= Time.deltaTime;
        if (playerEXP > 50 * playerLevel)
        {
            HasALevelUp = true;
        }
        if (HasALevelUp)
        {
            LevelUp();
            HasALevelUp = false;
        }

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
    void ShootingTimer()
    {
        shootingTime += Time.deltaTime;
        if (shootingTime >= 0.5)
        {
            isShooting = false;
        }
        if (shootingTime < 0.5)
        {
            isShooting = true;
        }
    }
    void Heal()
    {
        if (HealAmount > 0)
        {
            if (healingCooldown <= 0 && ((SP == 0) || (SP == 1)))
            {
                if (isHealing)
                {
                    anime.SetBool("IsHealing",true);
                }
                if (healingTimer >= healingTime)
                {
                    Debug.Log("SHould work down");
                    HealAmount -= 5;
                    _PH.playerHealth += 2;
                    healingTimer = 0f;
                    healingCooldown = 1f;
                    SP ++;
                }   
            }
        }
        
    }
    void HealingTimer()
    {
        if (isHealing)
        {
            healingTimer += Time.deltaTime;
        }
        else
        {
            healingTimer = 0f;
        }
    }
    void LevelUp()
    {
        playerLevel = playerLevel * 2;
        _PH.playerMaxHealth += 2;
        _PH.playerHealth = _PH.playerMaxHealth;
        AmmoMaxAmount += 1;
        AmmoAmount = AmmoMaxAmount;
        HealMaxAmount += 5;
        HealAmount = HealMaxAmount;
    }
}