const rootRoute = "/";

const overviewPageDisplayName = "Overview";
const overviewPageRoute = "/overview";

const productsPageDisplayName = "Products";
const productsPageRoute = "/products";

const statisticalPageDisplayName = "Statistical";
const statisticalPageRoute = "/statistical";

const clientsPageDisplayName = "Clients";
const clientsPageRoute = "/clients";

const ordersPageDisplayName = "Orders";
const ordersPageRoute = "/orders";

const authenticationPageDisplayName = "Log out";
const authenticationPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}

List<MenuItem> sideMenuItemRoutes = [
  MenuItem(overviewPageDisplayName, overviewPageRoute),
  MenuItem(statisticalPageDisplayName, statisticalPageRoute),
  MenuItem(productsPageDisplayName, productsPageRoute),
  MenuItem(ordersPageDisplayName, ordersPageRoute),
  MenuItem(clientsPageDisplayName, clientsPageRoute),
  MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
