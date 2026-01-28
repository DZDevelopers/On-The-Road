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
    [SerializeField] private Image Health_4;
    [SerializeField] private Image Health_5;
    [SerializeField] private Image Health_6;

    [SerializeField] private Sprite FullHealth;
    [SerializeField] private Sprite HalfHealth;
    [SerializeField] private Sprite NoHealth;

    [SerializeField] private Image Ammo_1;
    [SerializeField] private Image Ammo_2;
    [SerializeField] private Image Ammo_3;
    [SerializeField] private Image Ammo_4;
    [SerializeField] private Image Ammo_5;
    [SerializeField] private Image Ammo_6;
    [SerializeField] private Image Ammo_7;
    [SerializeField] private Image Ammo_8;
    [SerializeField] private Sprite FullAmmo;
    [SerializeField] private Sprite NoAmmo;

    [SerializeField] private Image Heal_1;
    [SerializeField] private Image Heal_2;
    [SerializeField] private Image Heal_3;
    [SerializeField] private Image Heal_4;
    [SerializeField] private Image Heal_5;
    [SerializeField] private Image Heal_6;
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
    #region
        if (_PH.playerHealth == 1)
        {
    Health_6.sprite = NoHealth;
    Health_5.sprite = NoHealth;
    Health_4.sprite = NoHealth;
    Health_3.sprite = NoHealth;
    Health_2.sprite = NoHealth;
    Health_1.sprite = HalfHealth;
        }
if (_PH.playerHealth == 2)
{
    Health_6.sprite = NoHealth;
    Health_5.sprite = NoHealth;
    Health_4.sprite = NoHealth;
    Health_3.sprite = NoHealth;
    Health_2.sprite = NoHealth;
    Health_1.sprite = FullHealth;
}
if (_PH.playerHealth == 3)
{
    Health_6.sprite = NoHealth;
    Health_5.sprite = NoHealth;
    Health_4.sprite = NoHealth;
    Health_3.sprite = NoHealth;
    Health_2.sprite = HalfHealth;
    Health_1.sprite = FullHealth;
}
if (_PH.playerHealth == 4)
{
    Health_6.sprite = NoHealth;
    Health_5.sprite = NoHealth;
    Health_4.sprite = NoHealth;
    Health_3.sprite = NoHealth;
    Health_2.sprite = FullHealth;
    Health_1.sprite = FullHealth;
}
if (_PH.playerHealth == 5)
{
    Health_6.sprite = NoHealth;
    Health_5.sprite = NoHealth;
    Health_4.sprite = NoHealth;
    Health_3.sprite = HalfHealth;
    Health_2.sprite = FullHealth;
    Health_1.sprite = FullHealth;
}
if (_PH.playerHealth == 6)
{
    Health_6.sprite = NoHealth;
    Health_5.sprite = NoHealth;
    Health_4.sprite = NoHealth;
    Health_3.sprite = FullHealth;
    Health_2.sprite = FullHealth;
    Health_1.sprite = FullHealth;
}
if (_PH.playerHealth == 7)
{
    Health_6.sprite = NoHealth;
    Health_5.sprite = NoHealth;
    Health_4.sprite = HalfHealth;
    Health_3.sprite = FullHealth;
    Health_2.sprite = FullHealth;
    Health_1.sprite = FullHealth;
}
if (_PH.playerHealth == 8)
{
    Health_6.sprite = NoHealth;
    Health_5.sprite = NoHealth;
    Health_4.sprite = FullHealth;
    Health_3.sprite = FullHealth;
    Health_2.sprite = FullHealth;
    Health_1.sprite = FullHealth;
}
if (_PH.playerHealth == 9)
{
    Health_6.sprite = NoHealth;
    Health_5.sprite = HalfHealth;
    Health_4.sprite = FullHealth;
    Health_3.sprite = FullHealth;
    Health_2.sprite = FullHealth;
    Health_1.sprite = FullHealth;
}
if (_PH.playerHealth == 10)
{
    Health_6.sprite = NoHealth;
    Health_5.sprite = FullHealth;
    Health_4.sprite = FullHealth;
    Health_3.sprite = FullHealth;
    Health_2.sprite = FullHealth;
    Health_1.sprite = FullHealth;
}
if (_PH.playerHealth == 11)
{
    Health_6.sprite = HalfHealth;
    Health_5.sprite = FullHealth;
    Health_4.sprite = FullHealth;
    Health_3.sprite = FullHealth;
    Health_2.sprite = FullHealth;
    Health_1.sprite = FullHealth;
}
    if (_PH.playerHealth == 12)
    {
        Health_6.sprite = FullHealth;
        Health_5.sprite = FullHealth;
        Health_4.sprite = FullHealth;
        Health_3.sprite = FullHealth;
        Health_2.sprite = FullHealth;
        Health_1.sprite = FullHealth;
    }
    #endregion
        // Ammo
    #region
        if (_PA.AmmoAmount == 0)
{
    Ammo_8.sprite = NoAmmo;
    Ammo_7.sprite = NoAmmo;
    Ammo_6.sprite = NoAmmo;
    Ammo_5.sprite = NoAmmo;
    Ammo_4.sprite = NoAmmo;
    Ammo_3.sprite = NoAmmo;
    Ammo_2.sprite = NoAmmo;
    Ammo_1.sprite = NoAmmo;
}

if (_PA.AmmoAmount == 1)
{
    Ammo_8.sprite = NoAmmo;
    Ammo_7.sprite = NoAmmo;
    Ammo_6.sprite = NoAmmo;
    Ammo_5.sprite = NoAmmo;
    Ammo_4.sprite = NoAmmo;
    Ammo_3.sprite = NoAmmo;
    Ammo_2.sprite = NoAmmo;
    Ammo_1.sprite = FullAmmo;
}

if (_PA.AmmoAmount == 2)
{
    Ammo_8.sprite = NoAmmo;
    Ammo_7.sprite = NoAmmo;
    Ammo_6.sprite = NoAmmo;
    Ammo_5.sprite = NoAmmo;
    Ammo_4.sprite = NoAmmo;
    Ammo_3.sprite = NoAmmo;
    Ammo_2.sprite = FullAmmo;
    Ammo_1.sprite = FullAmmo;
}

if (_PA.AmmoAmount == 3)
{
    Ammo_8.sprite = NoAmmo;
    Ammo_7.sprite = NoAmmo;
    Ammo_6.sprite = NoAmmo;
    Ammo_5.sprite = NoAmmo;
    Ammo_4.sprite = NoAmmo;
    Ammo_3.sprite = FullAmmo;
    Ammo_2.sprite = FullAmmo;
    Ammo_1.sprite = FullAmmo;
}

if (_PA.AmmoAmount == 4)
{
    Ammo_8.sprite = NoAmmo;
    Ammo_7.sprite = NoAmmo;
    Ammo_6.sprite = NoAmmo;
    Ammo_5.sprite = NoAmmo;
    Ammo_4.sprite = FullAmmo;
    Ammo_3.sprite = FullAmmo;
    Ammo_2.sprite = FullAmmo;
    Ammo_1.sprite = FullAmmo;
}

if (_PA.AmmoAmount == 5)
{
    Ammo_8.sprite = NoAmmo;
    Ammo_7.sprite = NoAmmo;
    Ammo_6.sprite = NoAmmo;
    Ammo_5.sprite = FullAmmo;
    Ammo_4.sprite = FullAmmo;
    Ammo_3.sprite = FullAmmo;
    Ammo_2.sprite = FullAmmo;
    Ammo_1.sprite = FullAmmo;
}

if (_PA.AmmoAmount == 6)
{
    Ammo_8.sprite = NoAmmo;
    Ammo_7.sprite = NoAmmo;
    Ammo_6.sprite = FullAmmo;
    Ammo_5.sprite = FullAmmo;
    Ammo_4.sprite = FullAmmo;
    Ammo_3.sprite = FullAmmo;
    Ammo_2.sprite = FullAmmo;
    Ammo_1.sprite = FullAmmo;
}

if (_PA.AmmoAmount == 7)
{
    Ammo_8.sprite = NoAmmo;
    Ammo_7.sprite = FullAmmo;
    Ammo_6.sprite = FullAmmo;
    Ammo_5.sprite = FullAmmo;
    Ammo_4.sprite = FullAmmo;
    Ammo_3.sprite = FullAmmo;
    Ammo_2.sprite = FullAmmo;
    Ammo_1.sprite = FullAmmo;
}

if (_PA.AmmoAmount == 8)
{
    Ammo_8.sprite = FullAmmo;
    Ammo_7.sprite = FullAmmo;
    Ammo_6.sprite = FullAmmo;
    Ammo_5.sprite = FullAmmo;
    Ammo_4.sprite = FullAmmo;
    Ammo_3.sprite = FullAmmo;
    Ammo_2.sprite = FullAmmo;
    Ammo_1.sprite = FullAmmo;
}
        #endregion
        // Healing
    #region
if (_PA.HealAmount == 0)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = NoHeal;
    Heal_2.sprite = NoHeal;
    Heal_1.sprite = NoHeal;
}
if (_PA.HealAmount == 1)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = NoHeal;
    Heal_2.sprite = NoHeal;
    Heal_1.sprite = SemiNoHeal;
}
if (_PA.HealAmount == 2)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = NoHeal;
    Heal_2.sprite = NoHeal;
    Heal_1.sprite = HalfNoHeal;
}
if (_PA.HealAmount == 3)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = NoHeal;
    Heal_2.sprite = NoHeal;
    Heal_1.sprite = HalfFullHeal;
}
if (_PA.HealAmount == 4)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = NoHeal;
    Heal_2.sprite = NoHeal;
    Heal_1.sprite = SemiFullHeal;
}
if (_PA.HealAmount == 5)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = NoHeal;
    Heal_2.sprite = NoHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 6)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = NoHeal;
    Heal_2.sprite = SemiNoHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 7)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = NoHeal;
    Heal_2.sprite = HalfNoHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 8)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = NoHeal;
    Heal_2.sprite = HalfFullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 9)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = NoHeal;
    Heal_2.sprite = SemiFullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 10)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = NoHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 11)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = SemiNoHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 12)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = HalfNoHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 13)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = HalfFullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 14)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = SemiFullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 15)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = NoHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 16)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = SemiNoHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 17)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = HalfNoHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 18)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = HalfFullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 19)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = SemiFullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 20)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = NoHeal;
    Heal_4.sprite = FullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 21)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = SemiNoHeal;
    Heal_4.sprite = FullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 22)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = HalfNoHeal;
    Heal_4.sprite = FullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 23)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = HalfFullHeal;
    Heal_4.sprite = FullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 24)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = SemiFullHeal;
    Heal_4.sprite = FullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 25)
{
    Heal_6.sprite = NoHeal;
    Heal_5.sprite = FullHeal;
    Heal_4.sprite = FullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 26)
{
    Heal_6.sprite = SemiNoHeal;
    Heal_5.sprite = FullHeal;
    Heal_4.sprite = FullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 27)
{
    Heal_6.sprite = HalfNoHeal;
    Heal_5.sprite = FullHeal;
    Heal_4.sprite = FullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 28)
{
    Heal_6.sprite = HalfFullHeal;
    Heal_5.sprite = FullHeal;
    Heal_4.sprite = FullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 29)
{
    Heal_6.sprite = SemiFullHeal;
    Heal_5.sprite = FullHeal;
    Heal_4.sprite = FullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
if (_PA.HealAmount == 30)
{
    Heal_6.sprite = FullHeal;
    Heal_5.sprite = FullHeal;
    Heal_4.sprite = FullHeal;
    Heal_3.sprite = FullHeal;
    Heal_2.sprite = FullHeal;
    Heal_1.sprite = FullHeal;
}
#endregion
        Exp.text = $"EXP:{_PA.playerEXP}/{_PA.playerLevel * 50}";

        if (_PH.playerMaxHealth > 6)
        {
            Health_4.gameObject.SetActive(true);
        }
        if (_PH.playerMaxHealth > 8)
        {
            Health_5.gameObject.SetActive(true);
        }
        if (_PH.playerMaxHealth > 10)
        {
            Health_6.gameObject.SetActive(true);
        }

        if (_PA.AmmoMaxAmount > 5)
        {
            Ammo_6.gameObject.SetActive(true);
        }
        if (_PA.AmmoMaxAmount > 6)
        {
            Ammo_7.gameObject.SetActive(true);
        }
        if (_PA.AmmoMaxAmount > 7)
        {
            Ammo_8.gameObject.SetActive(true);
        }

        if (_PA.HealMaxAmount > 15)
        {
            Heal_4.gameObject.SetActive(true);
        }
        if (_PA.HealMaxAmount > 20)
        {
            Heal_5.gameObject.SetActive(true);
        }
        if (_PA.HealMaxAmount > 25)
        {
            Heal_6.gameObject.SetActive(true);
        }
    }
}