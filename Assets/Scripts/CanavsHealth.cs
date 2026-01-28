using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class CanavsHealth : MonoBehaviour
{
    public PlayerHealth _PH;
    public PlayerAttack _PA;

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

    [SerializeField] private TextMeshProUGUI Exp;

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
        if (_PA.HealAmount == 15)
        {
            Heal_1.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_3.sprite = FullHeal;
        }
        if (_PA.HealAmount == 14)
        {           
            Heal_1.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_3.sprite = SemiFullHeal;
        }
        if (_PA.HealAmount == 13)
        {
            Heal_1.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_3.sprite = HalfFullHeal;
        }   
        if (_PA.HealAmount == 12)
        {
            Heal_1.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_3.sprite = HalfNoHeal;
        }
        if (_PA.HealAmount == 11)
        {
            Heal_1.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_3.sprite = SemiNoHeal;
        }
        if (_PA.HealAmount == 10)
        {
            Heal_1.sprite = FullHeal;
            Heal_2.sprite = FullHeal;
            Heal_3.sprite = NoHeal;
        }
        if (_PA.HealAmount == 9)
        {
            Heal_1.sprite = FullHeal;
            Heal_2.sprite = SemiFullHeal;
            Heal_3.sprite = NoHeal;
        }
        if (_PA.HealAmount == 8)
        {
            Heal_1.sprite = FullHeal;
            Heal_2.sprite = HalfFullHeal;
            Heal_3.sprite = NoHeal;
        }
        if (_PA.HealAmount == 7)
        {
            Heal_1.sprite = FullHeal;
            Heal_2.sprite = HalfNoHeal;
            Heal_3.sprite = NoHeal;
        }
        if (_PA.HealAmount == 6)
        {
            Heal_1.sprite = FullHeal;
            Heal_2.sprite = SemiNoHeal;
            Heal_3.sprite = NoHeal;
        }
        if (_PA.HealAmount == 5)
        {   
            Heal_1.sprite = FullHeal;
            Heal_2.sprite = NoHeal;
            Heal_3.sprite = NoHeal;
        }
        if (_PA.HealAmount == 4)
        {
            Heal_1.sprite = SemiFullHeal;
            Heal_2.sprite = NoHeal;
            Heal_3.sprite = NoHeal;
        }
        if (_PA.HealAmount == 3)
        {
            Heal_1.sprite = HalfFullHeal;
            Heal_2.sprite = NoHeal;
            Heal_3.sprite = NoHeal;
        }
        if (_PA.HealAmount == 2)
        {
            Heal_1.sprite = HalfNoHeal;
            Heal_2.sprite = NoHeal;
            Heal_3.sprite = NoHeal;
        }
        if (_PA.HealAmount == 1)
        {
            Heal_1.sprite = SemiNoHeal;
            Heal_2.sprite = NoHeal;
            Heal_3.sprite = NoHeal;
        }
        if (_PA.HealAmount <= 0)
        {
            Heal_1.sprite = NoHeal;
            Heal_2.sprite = NoHeal;
            Heal_3.sprite = NoHeal;
        }
        Exp.text = $"EXP:{_PA.playerEXP}/{_PA.playerLevel * 50}";
    }
}