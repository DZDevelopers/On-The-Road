using UnityEngine;
using UnityEngine.UI;

public class CanavsHealth : MonoBehaviour
{
    public PlayerHealth _PH;
    public PlayerAttack _PA;
    public PlayerAttack _PHE;

    [SerializeField] private Image Health_1;
    [SerializeField] private Image Health_2;
    [SerializeField] private Image Health_3;
    [SerializeField] private Sprite FullHealth;
    [SerializeField] private Sprite HalfHealth;
    [SerializeField] private Sprite NoHealth;

    [SerializeField] private Image Ammo_1;
    [SerializeField] private Image Ammo_2;
    [SerializeField] private Image Ammo_3;
    [SerializeField] private Image Ammo_4;
    [SerializeField] private Image Ammo_5;
    [SerializeField] private Sprite FullAmmo;
    [SerializeField] private Sprite NoAmmo;

    [SerializeField] private Image Heal_1;
    [SerializeField] private Image Heal_2;
    [SerializeField] private Image Heal_3;
    [SerializeField] private Sprite FullHeal;
    [SerializeField] private Sprite SemiFullHeal;
    [SerializeField] private Sprite HalfFullHeal;
    [SerializeField] private Sprite HalfNoHeal;
    [SerializeField] private Sprite SemiNoHeal;
    [SerializeField] private Sprite NoHeal;

    void Update()
    {
        // Health
        if (_PH.playerHealth == 6)
        {
            Health_3.sprite = FullHealth;
            Health_2.sprite = FullHealth;
            Health_1.sprite = FullHealth;
        }
        if (_PH.playerHealth == 5)
        {
            Health_3.sprite = HalfHealth;
            Health_2.sprite = FullHealth;
            Health_1.sprite = FullHealth;
        }
        if (_PH.playerHealth == 4)
        {
            Health_3.sprite = NoHealth;
            Health_2.sprite = FullHealth;
            Health_1.sprite = FullHealth;
        }
        if (_PH.playerHealth == 3)
        {
            Health_3.sprite = NoHealth;
            Health_2.sprite = HalfHealth;
            Health_1.sprite = FullHealth;
        }
        if (_PH.playerHealth == 2)
        {
            Health_3.sprite = NoHealth;
            Health_2.sprite = NoHealth;
            Health_1.sprite = FullHealth;
        }
        if (_PH.playerHealth == 1)
        {
            Health_3.sprite = NoHealth;
            Health_2.sprite = NoHealth;
            Health_1.sprite = HalfHealth;
        }

        // Ammo
        if (_PA.AmmoAmount == 5)
        {
            Ammo_5.sprite = FullAmmo;
            Ammo_4.sprite = FullAmmo;
            Ammo_3.sprite = FullAmmo;
            Ammo_2.sprite = FullAmmo;
            Ammo_1.sprite = FullAmmo;
        }
        if (_PA.AmmoAmount == 4)
        {
            Ammo_5.sprite = NoAmmo;
            Ammo_4.sprite = FullAmmo;
            Ammo_3.sprite = FullAmmo;
            Ammo_2.sprite = FullAmmo;
            Ammo_1.sprite = FullAmmo;
        }
        if (_PA.AmmoAmount == 3)
        {
            Ammo_5.sprite = NoAmmo;
            Ammo_4.sprite = NoAmmo;
            Ammo_3.sprite = FullAmmo;
            Ammo_2.sprite = FullAmmo;
            Ammo_1.sprite = FullAmmo;
        }
        if (_PA.AmmoAmount == 2)
        {
            Ammo_5.sprite = NoAmmo;
            Ammo_4.sprite = NoAmmo;
            Ammo_3.sprite = NoAmmo;
            Ammo_2.sprite = FullAmmo;
            Ammo_1.sprite = FullAmmo;
        }
        if (_PA.AmmoAmount == 1)
        {
            Ammo_5.sprite = NoAmmo;
            Ammo_4.sprite = NoAmmo;
            Ammo_3.sprite = NoAmmo;
            Ammo_2.sprite = NoAmmo;
            Ammo_1.sprite = FullAmmo;
        }
        if (_PA.AmmoAmount == 0)
        {
            Ammo_5.sprite = NoAmmo;
            Ammo_4.sprite = NoAmmo;
            Ammo_3.sprite = NoAmmo;
            Ammo_2.sprite = NoAmmo;
            Ammo_1.sprite = NoAmmo;
        }

        // Healing
        {
            Heal_3.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_1.sprite = FullHeal;
        }
        if (_PHE.HealAmount == 14)
        {
            Heal_3.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_1.sprite = SemiFullHeal;
        }
        if (_PHE.HealAmount == 13)
        {
            Heal_3.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_1.sprite = HalfFullHeal;
        }
        if (_PHE.HealAmount == 12)
        {
            Heal_3.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_1.sprite = HalfNoHeal;
        }
        if (_PHE.HealAmount == 11)
        {
            Heal_3.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_1.sprite = SemiNoHeal;
        }
        if (_PHE.HealAmount == 10)
        {
            Heal_3.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_1.sprite = NoHeal;
        }
        if (_PHE.HealAmount == 9)
        {
            Heal_3.sprite = FullHeal;
            Heal_2.sprite = SemiFullHeal;
            Heal_1.sprite = NoHeal;
        }
        if (_PHE.HealAmount == 8)
        {
            Heal_3.sprite = FullHeal;
            Heal_2.sprite = HalfFullHeal;
            Heal_1.sprite = NoHeal;
        }
        if (_PHE.HealAmount == 7)
        {
            Heal_3.sprite = FullHeal;
            Heal_2.sprite = HalfNoHeal;
            Heal_1.sprite = NoHeal;
        }
        if (_PHE.HealAmount == 6)
        {
            Heal_3.sprite = FullHeal;
            Heal_2.sprite = SemiNoHeal;
            Heal_1.sprite = NoHeal;
        }
        if (_PHE.HealAmount == 5)
        {
            Heal_3.sprite = FullHeal;
            Heal_2.sprite = NoHeal;
            Heal_1.sprite = NoHeal;
        }
        if (_PHE.HealAmount == 4)
        {
            Heal_3.sprite = SemiFullHeal;
            Heal_2.sprite = NoHeal;
            Heal_1.sprite = NoHeal;
        }
        if (_PHE.HealAmount == 3)
        {
            Heal_3.sprite = HalfFullHeal;
            Heal_2.sprite = NoHeal;
            Heal_1.sprite = NoHeal;
        }
        if (_PHE.HealAmount == 2)
        {
            Heal_3.sprite = HalfNoHeal;
            Heal_2.sprite = NoHeal;
            Heal_1.sprite = NoHeal;
        }
        if (_PHE.HealAmount == 1)
        {
            Heal_3.sprite = SemiNoHeal;
            Heal_2.sprite = NoHeal;
            Heal_1.sprite = NoHeal;
        }
        if (_PHE.HealAmount <= 0)
        {
            Heal_3.sprite = NoHeal;
            Heal_2.sprite = NoHeal;
            Heal_1.sprite = NoHeal;
        }
    }
}