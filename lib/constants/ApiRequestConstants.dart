// Servers integration with services & APIs
const String serverIp = 'Todo-Alb-1540653277.il-central-1.elb.amazonaws.com';
 // const String serverIp = 'localhost';
const String serverPort = '8080';
const String baseServerUrl = 'http://$serverIp:$serverPort/todoServer';

const String createUserDataUrl = '$baseServerUrl/user/addUser';

// Google Services & APIs
const String googleApiKey = 'AIzaSyAZbUFSgiv3NpN0IF5E437RJj6pvw9XEGI';
const String googleMapsDirectionsUrl =
    'https://maps.googleapis.com/maps/api/directions';
const String googleSignInAndroidClientId =
    '341327417169-35e8utfadqjh4ooph4fsun5lh5bbg5jg.apps.googleusercontent.com';
const String googleSignInIosClientId =
    '341327417169-6nnhq6mg7eep9vr6o3io0oc4lenekte2.apps.googleusercontent.com';
const List<String> googleSignInScopes = [
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

const String mapBoxApiKey =
    "pk.eyJ1IjoidG9kb2lzcmFlbCIsImEiOiJjbHI0bGNwODIxaHliMml0M29obnp2Z3AzIn0.gXQTKxNjFxNdQwvbOF4yZA";

// CellAct Services & APIs
const String pusherApiKey = 'c8d7df3975045ff40ff7';
const String pusherCluster = 'ap2';
const String cellActSmsServerUrl = 'https://la.cellactpro.com/unistart5.asp';
const String cellActSmsUsername = 'todo10';
const String cellActSmsPassword = 'n1blJSQ9';
const String cellActSmsSenderName = 'TODO';

// Intercom Services & APIs
const String intercomAppId = 'oeewtyne';
const String iosApiKey = 'ios_sdk-17951f891d44fcaf4e46a6b5acf18b5719acd162';
const String androidApiKey =
    'android_sdk-a1ff4f0ab96652faefbe48ad05b71cd9ebde3e10';

// Business base Inventory services & APIs
const String baseSizeUrl = '$baseServerUrl/size';
const String baseColorUrl = '$baseServerUrl/color';
const String baseDishUrl = '$baseServerUrl/assemblingDish';
const String baseExtrasUrl = '$baseServerUrl/extras';

// Business menu services & APIs
const String baseProductUrl = '$baseServerUrl/product';
const String setDiscountUrl = '$baseProductUrl/setDiscount';
const String setProductShowUrl = '$baseProductUrl/setProductShow';
const String setUnitInStockUrl = '$baseProductUrl/setUnitsInStock';
const String setSizeAmountUrl = '$baseSizeUrl/setSizeAmount';
const String setColorAmountUrl = '$baseColorUrl/setColorAmount';
const String setAssemblingDishOutOfStockUrl = '$baseDishUrl/setAssemblingDishOutOfStock';
const String setExtrasAmountUrl = '$baseExtrasUrl/setExtrasAmount';
