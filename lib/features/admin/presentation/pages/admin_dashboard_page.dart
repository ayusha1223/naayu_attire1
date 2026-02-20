import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:naayu_attire1/features/admin/data/services/admin_service.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() =>
      _AdminDashboardPageState();
}

class _AdminDashboardPageState
    extends State<AdminDashboardPage> {

  final AdminService _adminService = AdminService();

  bool isLoading = true;

  int totalOrders = 0;
  int totalUsers = 0;
  int totalPayments = 0;
  double totalRevenue = 0;

  List<dynamic> monthlyRevenue = [];

  @override
  void initState() {
    super.initState();
    loadDashboard();
    loadMonthlyRevenue();
  }

  /// ================================
  /// LOAD DASHBOARD
  /// ================================
  Future<void> loadDashboard() async {
    try {
      final response =
          await _adminService.getDashboardStats();

      print("RAW DASHBOARD: $response");

      final data =
          response["data"] ?? response;

      setState(() {
        totalOrders = data["totalOrders"] ?? 0;
        totalUsers = data["totalUsers"] ?? 0;
        totalPayments = data["totalPayments"] ?? 0;
        totalRevenue =
            (data["totalRevenue"] ?? 0)
                .toDouble();
        isLoading = false;
      });
    } catch (e) {
      print("Dashboard Error: $e");
      setState(() => isLoading = false);
    }
  }

  /// ================================
  /// LOAD MONTHLY REVENUE
  /// ================================
Future<void> loadMonthlyRevenue() async {
  try {
    final response =
        await _adminService.getMonthlyRevenue();

    print("RAW MONTHLY: $response");

    setState(() {
      monthlyRevenue = response; // ✅ directly assign
    });

  } catch (e) {
    print("Monthly Revenue Error: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Dashboard",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// =====================
                    /// STATS GRID
                    /// =====================
                    GridView.count(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.2,
                      children: [
                        DashboardCard(
                          title: "Total Orders",
                          value: totalOrders.toString(),
                          icon: Icons.shopping_cart,
                        ),
                        DashboardCard(
                          title: "Total Users",
                          value: totalUsers.toString(),
                          icon: Icons.people,
                        ),
                        DashboardCard(
                          title: "Revenue",
                          value:
                              "Rs ${totalRevenue.toStringAsFixed(0)}",
                          icon: Icons.attach_money,
                        ),
                        DashboardCard(
                          title: "Payments",
                          value:
                              totalPayments.toString(),
                          icon: Icons.payment,
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    const Text(
                      "Monthly Revenue",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding:
                          const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: SizedBox(
                        height: 250,
                        child: buildChart(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  /// ================================
  /// CHART
  /// ================================
  Widget buildChart() {
    if (monthlyRevenue.isEmpty) {
      return const Center(
        child: Text("No Revenue Data"),
      );
    }

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),

        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < monthlyRevenue.length) {
                  return Text(
                    monthlyRevenue[index]["month"]
                        .toString(),
                    style:
                        const TextStyle(fontSize: 10),
                  );
                }
                return const Text("");
              },
            ),
          ),
        ),

        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.2),
            ),
            spots: List.generate(
              monthlyRevenue.length,
              (index) => FlSpot(
                index.toDouble(),
                (monthlyRevenue[index]["revenue"]
                        as num)
                    .toDouble(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(icon,
              color: Colors.blue,
              size: 28),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}