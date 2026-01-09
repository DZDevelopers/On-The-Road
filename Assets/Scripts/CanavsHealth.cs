using UnityEngine;
using UnityEngine.UI;

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

    void Update()
    {
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
    }
}