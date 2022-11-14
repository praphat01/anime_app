class NavBar {
  final String path;
  final String name;

  const NavBar({required this.name, required this.path});
}

const itemsNavBar = [
  NavBar(
    name: "หน้าหลัก",
    path: 'assets/icons/home.svg',
  ),
  NavBar(
    name: "ชั้นหนังสือ",
    path: 'assets/icons/book-bookmark.svg',
  ),
  NavBar(
    name: "หมวดหมู่",
    path: 'assets/icons/book-open-cover.svg',
  ),
  NavBar(
    name: "สำนัก..",
    path: 'assets/icons/building.svg',
  ),
];
