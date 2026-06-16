import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Travel Service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ─────────────────────────────────────────────
// Login Page
// ─────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Login failed';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[400]!, Colors.blue[800]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flight_takeoff, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'Travel Service',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_errorMessage.isNotEmpty)
                          Text(_errorMessage,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Login',
                                    style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const RegisterPage()));
                          },
                          child: const Text('Don\'t have an account? Register'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Register Page
// ─────────────────────────────────────────────
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Registration failed';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[400]!, Colors.blue[800]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flight_takeoff, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text('Create Account',
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password (min 6 characters)',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_errorMessage.isNotEmpty)
                          Text(_errorMessage,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Register',
                                    style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Already have an account? Login'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Home Page (shell with bottom nav)
// ─────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTabPage(),
    const SearchPage(),
    const FavoritesPage(),
    const BookingsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Hotel model
// ─────────────────────────────────────────────
class HotelData {
  final String name;
  final String location;
  final String price;
  final double rating;
  final String imagePath;
  final String description;

  const HotelData({
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.description,
  });
}

final ValueNotifier<List<HotelData>> favoriteHotels =
    ValueNotifier<List<HotelData>>([]);

final List<HotelData> featuredHotels = [
  const HotelData(
    name: 'Grand Hotel Bali',
    location: 'Bali, Indonesia',
    price: '\$150/night',
    rating: 4.5,
    imagePath: 'IMAGES/Rooms/BaliR.jpg',
    description: 'Luxury Bali resort.',
  ),

  HotelData(
    name: 'Tokyo Stay',
    location: 'Tokyo, Japan',
    price: '\$200/night',
    rating: 4.8,
    imagePath: 'IMAGES/Rooms/TokyoR.jpg',
    description: 'Modern Tokyo hotel.',
  ),

  HotelData(
    name: 'Paris Luxury',
    location: 'Paris, France',
    price: '\$300/night',
    rating: 4.9,
    imagePath: 'IMAGES/Rooms/FranceR.jpg',
    description: 'Luxury Paris experience.',
  ),

  HotelData(
    name: 'Taipei Grand Hotel',
    location: 'Taipei, Taiwan',
    price: '\$180/night',
    rating: 4.7,
    imagePath: 'IMAGES/Rooms/TaipeiR.jpg',
    description: 'Luxury hotel in Taipei.',
  ),

  HotelData(
    name: 'Kaohsiung Harbor Hotel',
    location: 'Kaohsiung, Taiwan',
    price: '\$140/night',
    rating: 4.6,
    imagePath: 'IMAGES/Rooms/KHHR.jpg',
    description: 'Near Kaohsiung Harbor.',
  ),

  HotelData(
    name: 'KL Skyline Hotel',
    location: 'Kuala Lumpur, Malaysia',
    price: '\$160/night',
    rating: 4.7,
    imagePath: 'IMAGES/Rooms/KLR.jpg',
    description: 'Modern KL city hotel.',
  ),
];

class TourData {
  final String name;
  final String location;
  final String duration;
  final String price;
  final double rating;
  final String imagePath;
  final String description;

  const TourData({
    required this.name,
    required this.location,
    required this.duration,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.description,
  });
}

final List<TourData> featuredTours = [
  const TourData(
    name: 'Bali Cultural Tour',
    location: 'Bali, Indonesia',
    duration: '3 days',
    price: '\$199',
    rating: 4.7,
    imagePath: 'IMAGES/Tours/BaliT.jpg',
    description: 'Experience Bali temples, rice terraces, and local culture with a guided tour.',
  ),
  const TourData(
    name: 'Tokyo City Tour',
    location: 'Tokyo, Japan',
    duration: '1 day',
    price: '\$89',
    rating: 4.6,
    imagePath: 'IMAGES/Tours/TokyoT.jpg',
    description: 'Discover Tokyo landmarks, food markets, and vibrant neighborhoods in one day.',
  ),
  const TourData(
    name: 'Paris Evening Tour',
    location: 'Paris, France',
    duration: '4 hours',
    price: '\$129',
    rating: 4.8,
    imagePath: 'IMAGES/Tours/ParisT.jpg',
    description: 'Enjoy a magical evening tour through Paris highlights and riverside views.',
  ),
];

class Booking {
  final String title;
  final String type;
  final String date;
  final String time;
  final String arrivalDate;
  final String departureDate;
  final String stayDuration;
  final int quantity;
  final String cardLast4;
  final String guestName;
  final String guestId;
  final String status;

  Booking({
    required this.title,
    required this.type,
    required this.date,
    required this.time,
    required this.arrivalDate,
    required this.departureDate,
    required this.stayDuration,
    required this.quantity,
    required this.cardLast4,
    required this.guestName,
    required this.guestId,
    required this.status,
  });
}

final ValueNotifier<List<Booking>> bookings =
    ValueNotifier<List<Booking>>([]);

// ─────────────────────────────────────────────
// Home Tab Page
// ─────────────────────────────────────────────
class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final _searchController = TextEditingController();
  List<HotelData> _filteredHotels = featuredHotels;

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHotels = featuredHotels;
      } else {
        _filteredHotels = featuredHotels
            .where((h) =>
                h.name.toLowerCase().contains(query.toLowerCase()) ||
                h.location.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header + search bar ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[700]!],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome Back!',
                      style: TextStyle(
                          color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Where do you want to go?',
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearch,
                      decoration: const InputDecoration(
                        hintText: 'Search destinations or hotels...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Popular Destinations ──
                  const Text('Popular Destinations',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildDestinationCard(
                            'Bali, Indonesia', 'From \$299', 'images/BALI.jpg', context),
                        _buildDestinationCard(
                            'Tokyo, Japan', 'From \$599', 'images/TOKYO.jpg', context),
                        _buildDestinationCard(
                            'Paris, France', 'From \$799', 'images/FRANCE.jpg', context),
                        _buildDestinationCard(
                            'Taipei, Taiwan', 'From \$249', 'images/TAIPEI.jpg', context),
                        _buildDestinationCard(
                            'Kaohsiung, Taiwan', 'From \$699', 'images/KHH.jpg', context),
                        _buildDestinationCard(
                            'Kuala Lumpur, Malaysia', 'From \$399', 'images/KL.jpg', context),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Recommended Hotels ──
                  const Text('Recommended Hotels',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  if (_filteredHotels.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text('No hotels found.',
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ),
                    )
                  else
                    ..._filteredHotels
                        .map((hotel) => _buildHotelCard(hotel, context))
                        .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationCard(
      String title, String price, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DestinationDetailPage(title: title)),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.blue[700],
                child: Column(
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(price,
                        style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCard(HotelData hotel, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HotelDetailPage(hotel: hotel)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: Image.asset(
                hotel.imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotel.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(hotel.location,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text('${hotel.rating}',
                            style: const TextStyle(fontSize: 13)),
                        const Spacer(),
                        Text(hotel.price,
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<List<HotelData>>(
  valueListenable: favoriteHotels,
  builder: (context, favorites, _) {
    final isFavorite = favorites.contains(hotel);

    return Row(
      children: [
        IconButton(
          icon: Icon(
            isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            final updated = List<HotelData>.from(favorites);
            if (isFavorite) {
              updated.remove(hotel);} else {
    updated.add(hotel);
  }
  favoriteHotels.value = updated;
},
        ),
        const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  },
),
          ],
        ),
      ),
    );
  }
}

class BookingFormPage extends StatefulWidget {
  final String title;
  final String type;

  const BookingFormPage({super.key, required this.title, required this.type});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _arrivalController = TextEditingController();
  final _departureController = TextEditingController();
  final _timeController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _cardController = TextEditingController();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _dateController.dispose();
    _arrivalController.dispose();
    _departureController.dispose();
    _timeController.dispose();
    _quantityController.dispose();
    _cardController.dispose();
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final cardDigits = _cardController.text.trim().replaceAll(' ', '').replaceAll('-', '');
    final cardLast4 = cardDigits.length >= 4
        ? cardDigits.substring(cardDigits.length - 4)
        : cardDigits;

    final newBooking = Booking(
      title: widget.title,
      type: widget.type,
      date: widget.type == 'Flights' ? _dateController.text.trim() : _arrivalController.text.trim(),
      time: _timeController.text.trim(),
      arrivalDate: _arrivalController.text.trim(),
      departureDate: _departureController.text.trim(),
      stayDuration: _computeStayDuration(),
      quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
      cardLast4: cardLast4,
      guestName: _nameController.text.trim(),
      guestId: _idController.text.trim(),
      status: 'Confirmed',
    );

    bookings.value = [...bookings.value, newBooking];

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSummaryPage(booking: newBooking),
      ),
    );
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) {
      _dateController.text = _formatDate(selected);
    }
  }

  Future<void> _pickArrivalDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) {
      _arrivalController.text = _formatDate(selected);
      _updateStayDuration();
      if (_departureController.text.isNotEmpty) {
        _updateStayDuration();
      }
    }
  }

  Future<void> _pickDepartureDate() async {
    final arrivalDate = _arrivalController.text.isNotEmpty
        ? DateTime.parse(_arrivalController.text)
        : DateTime.now().add(const Duration(days: 1));
    final minDepartureDate = arrivalDate.add(const Duration(days: 1));
    
    // Use existing departure date if set, otherwise use minimum valid date
    final initialDate = _departureController.text.isNotEmpty
        ? DateTime.parse(_departureController.text)
        : minDepartureDate;
    
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDepartureDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) {
      _departureController.text = _formatDate(selected);
      _updateStayDuration();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}';
  }

  void _updateStayDuration() {
    if (_arrivalController.text.isEmpty || _departureController.text.isEmpty) return;
    try {
      final arrival = DateTime.parse(_arrivalController.text);
      final departure = DateTime.parse(_departureController.text);
      final nights = departure.difference(arrival).inDays;
      if (nights > 0) {
        _dateController.text = _formatDate(arrival);
      }
    } catch (_) {}
  }

  String _computeStayDuration() {
    if (_arrivalController.text.isEmpty || _departureController.text.isEmpty) {
      return '';
    }
    try {
      final arrival = DateTime.parse(_arrivalController.text);
      final departure = DateTime.parse(_departureController.text);
      final nights = departure.difference(arrival).inDays;
      return nights > 0 ? '$nights night(s)' : '';
    } catch (_) {
      return '';
    }
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 12, minute: 0),
    );
    if (selected != null) {
      _timeController.text = selected.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.title}'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Book ${widget.title}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                widget.type == 'Flights'
                    ? 'Choose your travel date, time, and ticket quantity.'
                    : 'Choose your dates, number of guests, and preferred time.',
                style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              if (widget.type == 'Hotels' || widget.type == 'Tours') ...[
                TextFormField(
                  controller: _arrivalController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: widget.type == 'Hotels' ? 'Check-in Date' : 'Start Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onTap: _pickArrivalDate,
                  validator: (value) => value == null || value.isEmpty ? 'Please select a start date' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _departureController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: widget.type == 'Hotels' ? 'Check-out Date' : 'End Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onTap: _pickDepartureDate,
                  validator: (value) => value == null || value.isEmpty ? 'Please select an end date' : null,
                ),
                const SizedBox(height: 12),
                if (_arrivalController.text.isNotEmpty && _departureController.text.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule, color: Colors.blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Stay duration: ${_computeStayDuration()}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
              ] else ...[
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Travel Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onTap: _pickDate,
                  validator: (value) => value == null || value.isEmpty ? 'Please select a travel date' : null,
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: widget.type == 'Flights' ? 'Departure Time' : 'Preferred Time',
                  suffixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onTap: _pickTime,
                validator: (value) => value == null || value.isEmpty ? 'Please select a time' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: widget.type == 'Flights' ? 'Tickets' : 'Number of people',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final parsed = int.tryParse(value ?? '0');
                  if (parsed == null || parsed < 1) {
                    return 'Enter a valid quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardController,
                decoration: InputDecoration(
                  labelText: 'Credit Card Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final digits = value?.replaceAll(' ', '').replaceAll('-', '') ?? '';
                  if (digits.length != 12) return 'Enter a valid card number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'ID Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter your ID' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Confirm Booking', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingSummaryPage extends StatelessWidget {
  final Booking booking;

  const BookingSummaryPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text('Booking Confirmed',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Your ${booking.type.toLowerCase()} booking for ${booking.title} is confirmed.',
                style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 24),
            _summaryTile('Booking Type', booking.type),
            _summaryTile('Destination / Hotel', booking.title),
            if (booking.arrivalDate.isNotEmpty)
              _summaryTile('Arrival / Start', booking.arrivalDate),
            if (booking.departureDate.isNotEmpty)
              _summaryTile('Departure / End', booking.departureDate),
            if (booking.stayDuration.isNotEmpty)
              _summaryTile('Duration', booking.stayDuration),
            if (booking.type == 'Flights')
              _summaryTile('Travel Date', booking.date),
            _summaryTile('Time', booking.time),
            _summaryTile('Quantity', booking.quantity.toString()),
            _summaryTile('Guest Name', booking.guestName),
            _summaryTile('Guest ID', booking.guestId),
            _summaryTile('Paid with', '•••• ${booking.cardLast4}'),
            _summaryTile('Status', booking.status),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('View My Bookings', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue[700]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back to Home', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Hotel Detail Page
// ─────────────────────────────────────────────
class HotelDetailPage extends StatelessWidget {
  final HotelData hotel;

  const HotelDetailPage({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.blue[700],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(hotel.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              background: Image.asset(hotel.imagePath, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue, size: 18),
                      const SizedBox(width: 4),
                      Text(hotel.location,
                          style: TextStyle(color: Colors.grey[700], fontSize: 15)),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('${hotel.rating}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(hotel.price,
                      style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text('About',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(hotel.description,
                      style: TextStyle(
                          color: Colors.grey[700], fontSize: 15, height: 1.6)),
                  const SizedBox(height: 30),
                  // Amenities
                  const Text('Amenities',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _amenityChip(Icons.wifi, 'Free WiFi'),
                      _amenityChip(Icons.pool, 'Pool'),
                      _amenityChip(Icons.spa, 'Spa'),
                      _amenityChip(Icons.restaurant, 'Restaurant'),
                      _amenityChip(Icons.local_parking, 'Parking'),
                      _amenityChip(Icons.fitness_center, 'Gym'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingFormPage(
                              title: hotel.name,
                              type: 'Hotels',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Book Now',
                          style:
                              TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _amenityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(color: Colors.blue[700], fontSize: 13)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Tour Detail Page
// ─────────────────────────────────────────────
class TourDetailPage extends StatelessWidget {
  final TourData tour;

  const TourDetailPage({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.blue[700],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(tour.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              background: Image.asset(tour.imagePath, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue[700], size: 18),
                      const SizedBox(width: 4),
                      Text(tour.location,
                          style: TextStyle(color: Colors.grey[700], fontSize: 15)),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('${tour.rating}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(tour.duration,
                      style: TextStyle(color: Colors.blue[700], fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(tour.price,
                      style: TextStyle(color: Colors.blue[700], fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  const Text('Tour Description',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(tour.description,
                      style: TextStyle(color: Colors.grey[700], fontSize: 15, height: 1.6)),
                  const SizedBox(height: 30),
                  const Text('What to expect',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _detailBullet('Professional local guide'),
                  _detailBullet('Transportation included'),
                  _detailBullet('Small group experience'),
                  _detailBullet('Meals and entrance fees as shown'),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingFormPage(
                              title: tour.name,
                              type: 'Tours',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Book Tour',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.blue, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Search Page
// ─────────────────────────────────────────────
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _selectedCategory = 'Hotels';
  String _query = '';

  final List<Map<String, dynamic>> _allItems = [
    {
      'name': 'Grand Hotel Bali',
      'type': 'Hotels',
      'icon': Icons.hotel,
      'sub': 'Bali, Indonesia',
      'image': 'IMAGES/Rooms/BaliR.jpg'
    },
    {
      'name': 'Tokyo Stay',
      'type': 'Hotels',
      'icon': Icons.hotel,
      'sub': 'Tokyo, Japan',
      'image': 'IMAGES/Rooms/TokyoR.jpg'
    },
    {
      'name': 'Paris Luxury',
      'type': 'Hotels',
      'icon': Icons.hotel,
      'sub': 'Paris, France',
      'image': 'IMAGES/Rooms/FranceR.jpg'
    },
    {
      'name': 'Taipei Grand Hotel',
      'type': 'Hotels',
      'icon': Icons.hotel,
      'sub': 'Taipei, Taiwan',
      'image': 'IMAGES/Rooms/TaipeiR.jpg'
    },
    {
      'name': 'Kaohsiung Harbor Hotel',
      'type': 'Hotels',
      'icon': Icons.hotel,
      'sub': 'Kaohsiung, Taiwan',
      'image': 'IMAGES/Rooms/KHHR.jpg'
    },
    {
      'name': 'KL Skyline Hotel',
      'type': 'Hotels',
      'icon': Icons.hotel,
      'sub': 'Kuala Lumpur, Malaysia',
      'image': 'IMAGES/Rooms/KLR.jpg'
    },
    {
      'name': 'Bali → Tokyo Flight',
      'type': 'Flights',
      'icon': Icons.flight,
      'sub': 'Economy · 7h 30m',
      'image': 'IMAGES/BALI.jpg'
    },
    {
      'name': 'Paris → Bali Flight',
      'type': 'Flights',
      'icon': Icons.flight,
      'sub': 'Business · 14h',
      'image': 'IMAGES/FRANCE.jpg'
    },
    {
      'name': 'Bali Cultural Tour',
      'type': 'Tours',
      'icon': Icons.tour,
      'sub': '3 days · \$199',
      'image': 'IMAGES/Tours/BaliT.jpg'
    },
    {
      'name': 'Tokyo City Tour',
      'type': 'Tours',
      'icon': Icons.tour,
      'sub': '1 day · \$89',
      'image': 'IMAGES/Tours/TokyoT.jpg'
    },
    {
      'name': 'Paris Evening Tour',
      'type': 'Tours',
      'icon': Icons.tour,
      'sub': '4 hours · \$129',
      'image': 'IMAGES/Tours/ParisT.jpg'
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    return _allItems.where((item) {
      final matchCategory = item['type'] == _selectedCategory;
      final matchQuery = _query.isEmpty ||
          item['name'].toLowerCase().contains(_query.toLowerCase()) ||
          item['sub'].toLowerCase().contains(_query.toLowerCase());
      return matchCategory && matchQuery;
    }).toList();
  }

  String _hotelPrice(String name) {
    switch (name) {
      case 'Grand Hotel Bali':
        return '\$150/night';
      case 'Tokyo Stay':
        return '\$200/night';
      case 'Paris Luxury':
        return '\$300/night';
      case 'Taipei Grand Hotel':
        return '\$180/night';
      case 'Kaohsiung Harbor Hotel':
        return '\$140/night';
      case 'KL Skyline Hotel':
        return '\$160/night';
      default:
        return 'From \$149/night';
    }
  }

  double _hotelRating(String name) {
    switch (name) {
      case 'Grand Hotel Bali':
        return 4.5;
      case 'Tokyo Stay':
        return 4.8;
      case 'Paris Luxury':
        return 4.9;
      case 'Taipei Grand Hotel':
        return 4.7;
      case 'Kaohsiung Harbor Hotel':
        return 4.6;
      case 'KL Skyline Hotel':
        return 4.7;
      default:
        return 4.4;
    }
  }

  String _hotelDescription(String name) {
    switch (name) {
      case 'Grand Hotel Bali':
        return 'Enjoy luxury resort living with beach access, pool, and local culture.';
      case 'Tokyo Stay':
        return 'Modern rooms close to restaurants, subway access, and city nightlife.';
      case 'Paris Luxury':
        return 'Elegant Paris hotel near landmarks, shopping, and gourmet dining.';
      case 'Taipei Grand Hotel':
        return 'Comfortable stay with city views, free WiFi, and local specialties.';
      case 'Kaohsiung Harbor Hotel':
        return 'Relax near the harbor with stylish rooms and easy transport links.';
      case 'KL Skyline Hotel':
        return 'Enjoy downtown comfort with rooftop views and premium service.';
      default:
        return 'A fantastic stay with great service and excellent amenities.';
    }
  }

  TourData _tourForItem(String name) {
    return featuredTours.firstWhere(
      (tour) => tour.name == name,
      orElse: () => featuredTours.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Search',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search destinations, hotels, flights...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _query = ''),
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: ['Hotels', 'Flights', 'Tours']
                  .map((cat) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: _selectedCategory == cat
                                  ? Colors.blue[700]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: _selectedCategory == cat
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(
              _query.isEmpty ? 'All $_selectedCategory' : 'Results for "$_query"',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text('No results found for "$_query"',
                              style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final item = _filtered[index];
                        return GestureDetector(
                      onTap: () {
                        if (item['type'] == 'Hotels') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HotelDetailPage(
                                hotel: HotelData(
                                  name: item['name'] as String,
                                  location: item['sub'] as String,
                                  price: _hotelPrice(item['name'] as String),
                                  rating: _hotelRating(item['name'] as String),
                                  imagePath: item['image'] as String,
                                  description: _hotelDescription(item['name'] as String),
                                ),
                              ),
                            ),
                          );
                        } else if (item['type'] == 'Tours') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TourDetailPage(
                                tour: _tourForItem(item['name'] as String),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                item['image'] as String,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name'] as String,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  Text(item['sub'] as String,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                          height: 1.4)),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(item['icon'] as IconData,
                                          color: Colors.blue[700], size: 18),
                                      const SizedBox(width: 6),
                                      Text(item['type'] as String,
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 13)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.book_online,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingFormPage(
                                      title: item['name'] as String,
                                      type: item['type'] as String,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Favorites Page
// ─────────────────────────────────────────────
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder<List<HotelData>>(
        valueListenable: favoriteHotels,
        builder: (context, favorites, _) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: favorites.isEmpty
                  ? const Center(
                      child: Text(
                        'No favorite hotels yet.',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final hotel = favorites[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Image.asset(
                              hotel.imagePath,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(hotel.name),
                            subtitle: Text(hotel.location),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                favoriteHotels.value =
                                    List.from(favorites)
                                      ..remove(hotel);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bookings Page
// ─────────────────────────────────────────────
class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Bookings',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder<List<Booking>>(
                valueListenable: bookings,
                builder: (context, currentBookings, _) {
                  if (currentBookings.isEmpty) {
                    return const Center(
                      child: Text(
                        'No bookings yet. Make a reservation from the app.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: currentBookings.length,
                    itemBuilder: (context, index) {
                      final booking = currentBookings[index];
                      return _buildBookingCard(
                          booking.title,
                          '${booking.date} · ${booking.time} · ${booking.quantity} ${booking.type == 'Flights' ? 'tickets' : 'people'}',
                          booking.status);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(String title, String date, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: status == 'Confirmed'
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == 'Confirmed'
                        ? Colors.green[700]
                        : Colors.orange[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Profile Page
// ─────────────────────────────────────────────
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _displayName = '';

  @override
  void initState() {
    super.initState();
    _displayName =
        FirebaseAuth.instance.currentUser?.displayName ?? 'Traveler';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.blue[100],
                  child: Icon(Icons.person, size: 55, color: Colors.blue[700]),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue[700],
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt,
                        size: 16, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Photo upload coming soon!')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _displayName.isNotEmpty ? _displayName : 'Traveler',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(user?.email ?? 'No Email',
                style: TextStyle(color: Colors.grey[600], fontSize: 15)),
            const SizedBox(height: 30),

            // Options
            _buildProfileOption(
              Icons.edit,
              'Edit Profile',
              () => _showEditProfileDialog(context),
            ),
            _buildProfileOption(
              Icons.security,
              'Account & Security',
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AccountSecurityPage())),
            ),
            _buildProfileOption(
              Icons.help_outline,
              'Help & Support',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HelpSupportPage())),
            ),
            _buildProfileOption(
              Icons.info_outline,
              'About',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AboutPage())),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Logout',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue[700]),
            const SizedBox(width: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: _displayName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Display Name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              await FirebaseAuth.instance.currentUser
                  ?.updateDisplayName(newName);
              if (!context.mounted) return;
              setState(() {
                _displayName = newName;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated!')),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700]),
            child: const Text('Save',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Account & Security Page
// ─────────────────────────────────────────────
class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Security'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionHeader('Account Information'),
          _infoTile(Icons.email, 'Email', user?.email ?? 'Not set'),
          _infoTile(Icons.verified_user, 'Email Verified',
              user?.emailVerified == true ? 'Yes' : 'No'),
          const SizedBox(height: 24),
          _sectionHeader('Security'),
          _actionTile(
            Icons.lock_reset,
            'Change Password',
            'Send a password reset link to your email',
            () async {
              if (user?.email != null) {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: user!.email!);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Password reset email sent!')),
                );
              }
            },
          ),
          _actionTile(
            Icons.security,
            'Two-Factor Authentication',
            'Add an extra layer of security to your account',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('2FA coming soon!')),
              );
            },
          ),
          const SizedBox(height: 24),
          _sectionHeader('Privacy'),
          _actionTile(
            Icons.delete_outline,
            'Delete Account',
            'Permanently remove your account and data',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Contact support to delete your account.')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
              letterSpacing: 0.8)),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionTile(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Help & Support Page
// ─────────────────────────────────────────────
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[600]!]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.support_agent, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text('We\'re here to help',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('24/7 support for all your travel needs',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _faqTile('How do I make a booking?',
              'Browse our destinations or hotels, tap on the one you\'re interested in, then press "Book Now". Follow the prompts to complete your reservation.'),
          _faqTile('Can I cancel my booking?',
              'Yes, bookings can be cancelled up to 48 hours before check-in for a full refund. Cancellations within 48 hours may incur a fee. Visit "My Bookings" to manage your reservations.'),
          _faqTile('How do I change my travel dates?',
              'Go to "My Bookings", select the booking you\'d like to modify, and tap "Change Dates". Availability and pricing may vary for new dates.'),
          _faqTile('Is my payment information secure?',
              'Absolutely. All transactions are encrypted using industry-standard SSL technology. We never store your full card details on our servers.'),
          _faqTile('How do I earn reward points?',
              'Every completed booking earns you TravelPoints. 1 point per \$1 spent on hotels, 2 points per \$1 on tour packages. Points can be redeemed for discounts on future bookings.'),
          const SizedBox(height: 24),
          const Text('Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _contactTile(Icons.email, 'Email Support', 'support@travelapp.com'),
          _contactTile(Icons.phone, 'Phone Support', '+1 (800) 123-4567'),
          _contactTile(Icons.chat, 'Live Chat', 'Available 9am–9pm daily'),
        ],
      ),
    );
  }

  Widget _faqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(question,
            style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer,
                style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _contactTile(IconData icon, String title, String detail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[50],
            child: Icon(icon, color: Colors.blue[700], size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
              Text(detail,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// About Page
// ─────────────────────────────────────────────
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[700]!]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Icon(Icons.flight_takeoff, size: 64, color: Colors.white),
                  SizedBox(height: 12),
                  Text('Travel Service',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Version 1.0.0',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _aboutSection(
              'Our Mission',
              'Travel Service exists to make world-class travel accessible to everyone. '
                  'We believe that exploring new places, cultures, and experiences should be '
                  'effortless — and that\'s exactly what we\'ve built. From the moment you '
                  'search for a destination to the second you check out of your hotel, '
                  'we\'re with you every step of the way.',
            ),
            _aboutSection(
              'What We Offer',
              '• Curated hotel selections in top destinations worldwide\n'
                  '• Real-time flight search and booking\n'
                  '• Guided tours and cultural experiences\n'
                  '• 24/7 customer support\n'
                  '• Flexible cancellation on most bookings\n'
                  '• TravelPoints rewards on every purchase',
            ),
            _aboutSection(
              'Our Story',
              'Founded in 2023 by a team of passionate travelers and engineers, '
                  'Travel Service was born from frustration with clunky, outdated booking '
                  'platforms. We set out to build something better — an app that feels as '
                  'exciting as travel itself. Today, we serve thousands of travelers across '
                  'the globe and are constantly adding new destinations and features.',
            ),
            _aboutSection(
              'Legal',
              'By using this application you agree to our Terms of Service and Privacy Policy. '
                  'All content, pricing, and availability is subject to change. '
                  '© 2025 Travel Service. All rights reserved.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutSection(String title, String body) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700])),
          const SizedBox(height: 10),
          Text(body,
              style: TextStyle(
                  color: Colors.grey[700], fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Destination Detail Page
// ─────────────────────────────────────────────
class DestinationDetailPage extends StatelessWidget {
  final String title;

  const DestinationDetailPage({super.key, required this.title});

  String getDestinationImage(String title) {
  switch (title) {
    case 'Bali, Indonesia':
      return 'IMAGES/BALI.jpg';

    case 'Tokyo, Japan':
      return 'IMAGES/TOKYO.jpg';

    case 'Paris, France':
      return 'IMAGES/FRANCE.jpg';

    case 'Taipei, Taiwan':
      return 'IMAGES/TAIPEI.jpg';

    case 'Kaohsiung, Taiwan':
      return 'IMAGES/KHH.jpg';

    case 'Kuala Lumpur, Malaysia':
      return 'IMAGES/KL.jpg';

    default:
      return 'IMAGES/BALI.jpg';
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title), backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
  getDestinationImage(title),
  height: 250,
  width: double.infinity,
  fit: BoxFit.cover,
),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text('4.8 (1,234 reviews)'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('About',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Discover the beauty of $title. Experience amazing culture, delicious food, and breathtaking scenery.',
                    style: TextStyle(
                        color: Colors.grey[700], fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Booking feature coming soon!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Book Now',
                          style:
                              TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

