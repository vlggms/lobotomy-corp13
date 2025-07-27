#define is_ego_weapon(A) (istype(A, /obj/item/ego_weapon) && !istype(A, /obj/item/ego_weapon/ranged/clerk))

#define is_ego_ranged_weapon(A) (istype(A, /obj/item/ego_weapon/ranged) && !istype(A, /obj/item/ego_weapon/ranged/clerk))

#define is_ego_melee_weapon(A) (is_ego_weapon(A) && !is_ego_ranged_weapon(A))
