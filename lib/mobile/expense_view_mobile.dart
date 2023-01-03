import 'package:budget_app_starting/components.dart';
import 'package:budget_app_starting/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

bool isLoading = true;

class ExpenseViewMobile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    double deviceWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      viewModelProvider.expensesStream();
      viewModelProvider.incomeStream();
      isLoading = false;
    }

    int totalExpense = 0;

    int totalIncome = 0;

    void calculate() {
      for (int i = 0; i < viewModelProvider.expensesAmount.length; i++) {
        totalExpense =
            totalExpense + int.parse(viewModelProvider.expensesAmount[i]);
      }
      for (int i = 0; i < viewModelProvider.incomesAmount.length; i++) {
        totalIncome =
            totalIncome + int.parse(viewModelProvider.incomesAmount[i]);
      }
    }

    calculate();
    int budgetLeft = totalIncome - totalExpense;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Poppins(
            text: 'Dashboard',
            size: 20.0,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white, size: 30.0),
          actions: [
            IconButton(
                onPressed: () async {
                  /// reset function
                  await viewModelProvider.reset();
                },
                icon: Icon(Icons.refresh)),
          ],
        ),
        // drawer
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DrawerHeader(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.0, color: Colors.black)),
                  child: CircleAvatar(
                    radius: 180.0,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/logo.png',
                      height: 100.0,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              MaterialButton(
                onPressed: () async {
                  await viewModelProvider.logout();
                },
                elevation: 20.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                height: 50.0,
                minWidth: 200.0,
                color: Colors.black,
                child: OpenSans(
                  text: 'Logout',
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      await launchUrl(
                          Uri.parse('https://www.instagram.com/amansk418/'));
                    },
                    icon: SvgPicture.asset(
                      'assets/instagram.svg',
                      color: Colors.black,
                      width: 35.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      launchUrl(
                          Uri.parse('https://www.facebook.com/sk.aman.3979'));
                    },
                    icon: SvgPicture.asset(
                      'assets/facebook.svg',
                      color: Colors.black,
                      width: 35.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      launchUrl(Uri.parse(
                          'https://www.linkedin.com/in/sheikh-aman-693183237/'));
                    },
                    icon: SvgPicture.asset(
                      'assets/linkedin.svg',
                      color: Colors.black,
                      width: 35.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 40.0,
            ),
            Column(
              children: [
                Container(
                  height: 240.0,
                  width: deviceWidth / 1.5,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poppins(
                            text: 'Budget left',
                            size: 14.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: 'Total expense',
                            size: 14.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: 'Total income',
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Divider(
                          indent: 40.0,
                          endIndent: 40.0,
                          color: Colors.grey,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poppins(
                            text: budgetLeft.toString(),
                            size: 14.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: totalExpense.toString(),
                            size: 14.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: totalIncome.toString(),
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Add expense

                    SizedBox(
                      height: 40.0,
                      width: 155.0,
                      child: MaterialButton(
                        onPressed: () async {
                          await viewModelProvider.addExpense(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15.0,
                            ),
                            OpenSans(
                              text: 'Add Expense',
                              size: 14.0,
                              color: Colors.white,
                            )
                          ],
                        ),
                        splashColor: Colors.grey,
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 10.0,
                    ),

                    //Add income
                    SizedBox(
                      height: 40.0,
                      width: 155.0,
                      child: MaterialButton(
                        onPressed: () async {
                          await viewModelProvider.addIncome(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15.0,
                            ),
                            OpenSans(
                              text: 'Add Income',
                              size: 14.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        splashColor: Colors.grey,
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expense list
                  Expanded(
                    child: Column(
                      children: [
                        OpenSans(text: 'Expenses', size: 15.0),
                        Container(
                          padding: const EdgeInsets.all(7.0),
                          height: 210.0,
                          width: 180.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            border: Border.all(width: 1.0, color: Colors.black),
                          ),
                          child: ListView.builder(
                            itemCount: viewModelProvider.expensesAmount.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Poppins(
                                      text:
                                          viewModelProvider.expensesName[index],
                                      size: 12.0),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Poppins(
                                        text: viewModelProvider
                                            .expensesAmount[index],
                                        size: 12.0),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  // Income list
                  Expanded(
                    child: Column(
                      children: [
                        OpenSans(text: 'Income', size: 15.0),
                        Container(
                          padding: const EdgeInsets.all(7.0),
                          height: 210.0,
                          width: 180.0,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: ListView.builder(
                            itemCount: viewModelProvider.incomesAmount.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Poppins(
                                      text:
                                          viewModelProvider.incomesName[index],
                                      size: 12.0),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Poppins(
                                        text: viewModelProvider
                                            .incomesAmount[index],
                                        size: 12.0),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
