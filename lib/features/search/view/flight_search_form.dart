// lib/features/search/widgets/flight_search_form.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glide/core/theme/app_colors.dart';
import 'package:intl/intl.dart';

import '../../../core/shared/helper.dart';
import '../../../core/shared/widgets/widgets.dart';
import '../model/airport_model.dart';
import '../viewmodel/search_cubit.dart';
import '../viewmodel/search_states.dart';

class FlightSearchForm extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFlightSearchRequested;

  const FlightSearchForm({super.key, this.onFlightSearchRequested});

  @override
  State<FlightSearchForm> createState() => _FlightSearchFormState();
}

class _FlightSearchFormState extends State<FlightSearchForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController departureDateController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();
  final TextEditingController passengersController = TextEditingController(
    text: '1',
  );

  bool isOneWay = false;
  String selectedClass = 'ECONOMY';

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    departureDateController.dispose();
    returnDateController.dispose();
    passengersController.dispose();
    super.dispose();
  }

  // Date picker function
  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller, {
    DateTime? firstDate,
    bool isReturn = false,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isReturn ? firstDate : DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: Theme.of(context).primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);

      // If departure date is selected and it's after return date, clear return date
      if (controller == departureDateController &&
          returnDateController.text.isNotEmpty) {
        DateTime returnDate = DateFormat(
          'yyyy-MM-dd',
        ).parse(returnDateController.text);
        if (picked.isAfter(returnDate)) {
          returnDateController.clear();
        }
      }
    }
  }

  // Custom airport search field with cubit integration
  Widget buildAirportSearchField({
    required TextEditingController controller,
    required String hintText,
    required bool isFromField,
    required IconData suffixIcon,
  }) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        List<Airport> suggestions = [];
        bool isSearching = false;

        if (state is AirportSearchSuccess && state.isFromField == isFromField) {
          suggestions = state.airports;
          log(suggestions.toString());
        } else if (state is AirportSearchLoading &&
            state.isFromField == isFromField) {
          isSearching = true;
        }

        return Column(
          children: [
            buildTextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              validator: validateIATACode,
              hintText: hintText,
              inputFormatters: [UpperCaseTextFormatter()],
              suffixIcon: isSearching
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Icon(suffixIcon, color: Colors.grey),
              onChanged: (value) {
                // Only search if the input looks like a city name (more than 3 chars)
                if (value.length > 3) {
                  context.read<SearchCubit>().searchAirports(
                    value,
                    isFromField: isFromField,
                  );
                } else {
                  context.read<SearchCubit>().clearAirportSuggestions();
                }
              },
            ),

            // Airport suggestions
            if (suggestions.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2D3E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final airport = suggestions[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        '${airport.iata} - ${airport.name}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${airport.city}, ${airport.country}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                      onTap: () {
                        controller.text = airport.iata;
                        context.read<SearchCubit>().clearAirportSuggestions();
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  // Custom material button builder

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip type toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2D3E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Animated sliding background
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: isOneWay
                      ? MediaQuery.of(context).size.width / 2 - 8
                      : 0,
                  right: isOneWay
                      ? 0
                      : MediaQuery.of(context).size.width / 2 - 8,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                // Content row
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isOneWay = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: !isOneWay
                                        ? Colors.white
                                        : Colors.grey[400],
                                    fontWeight: !isOneWay
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                              child: const Text('Round trip'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isOneWay = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: isOneWay
                                        ? Colors.white
                                        : Colors.grey[400],
                                    fontWeight: isOneWay
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                              child: const Text('One way'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // From field with search
          buildAirportSearchField(
            controller: fromController,
            hintText: 'From (city or airport code)',
            isFromField: true,
            suffixIcon: Icons.flight_takeoff,
          ),

          const SizedBox(height: 16),

          // To field with search
          buildAirportSearchField(
            controller: toController,
            hintText: 'To (city or airport code)',
            isFromField: false,
            suffixIcon: Icons.flight_land,
          ),

          const SizedBox(height: 16),

          // Date fields
          Row(
            children: [
              Expanded(
                child: buildTextFormField(
                  controller: departureDateController,
                  keyboardType: TextInputType.none,
                  validator: validateDate,
                  hintText: 'Departure',
                  readOnly: true,
                  onTap: () => _selectDate(context, departureDateController),
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedOpacity(
                  opacity: isOneWay ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: buildTextFormField(
                    controller: returnDateController,
                    keyboardType: TextInputType.none,
                    validator: isOneWay ? null : validateDate,
                    hintText: 'Return',
                    readOnly: true,
                    onTap: isOneWay
                        ? null
                        : () {
                            DateTime? firstDate;
                            if (departureDateController.text.isNotEmpty) {
                              firstDate = DateFormat(
                                'yyyy-MM-dd',
                              ).parse(departureDateController.text);
                            }
                            _selectDate(
                              context,
                              returnDateController,
                              firstDate: firstDate,
                              isReturn: true,
                            );
                          },
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Passengers and Class
          Row(
            children: [
              Expanded(
                flex: 2,
                child: buildTextFormField(
                  controller: passengersController,
                  keyboardType: TextInputType.number,
                  validator: validatePassengers,
                  hintText: 'Passengers',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  suffixIcon: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedClass,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF2A2D3E),
                      style: Theme.of(context).textTheme.bodyMedium,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'ECONOMY',
                          child: Text('Economy'),
                        ),
                        DropdownMenuItem(
                          value: 'PREMIUM_ECONOMY',
                          child: Text('Premium Economy'),
                        ),
                        DropdownMenuItem(
                          value: 'BUSINESS',
                          child: Text('Business'),
                        ),
                        DropdownMenuItem(
                          value: 'FIRST',
                          child: Text('First Class'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedClass = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Search button with loading state to prevent multiple submissions
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                height: 45,
                child: buildMaterialButton(
                  onPressed: state is SearchLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            // Prepare search parameters for Amadeus API
                            Map<String, dynamic> searchParams = {
                              'originLocationCode': fromController.text.trim(),
                              'destinationLocationCode': toController.text
                                  .trim(),
                              'departureDate': departureDateController.text,
                              'adults': int.parse(passengersController.text),
                              'travelClass': selectedClass,
                              'nonStop': false,
                              'max': 10, // Limit for free tier
                            };

                            if (!isOneWay &&
                                returnDateController.text.isNotEmpty) {
                              searchParams['returnDate'] =
                                  returnDateController.text;
                            }

                            // Call the callback function
                            if (widget.onFlightSearchRequested != null) {
                              widget.onFlightSearchRequested!(searchParams);
                            }
                          }
                        },
                  label: 'Search',
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Popular flights section
          Text(
            'Popular flights',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          // Popular flight items
          _buildPopularFlightItem(
            title: 'Direct flight',
            subtitle: 'New York to Los Angeles',
            onTap: () {
              fromController.text = 'JFK';
              toController.text = 'LAX';
            },
          ),

          const SizedBox(height: 12),

          _buildPopularFlightItem(
            title: 'Direct flight',
            subtitle: 'Los Angeles to London',
            onTap: () {
              fromController.text = 'LAX';
              toController.text = 'LHR';
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPopularFlightItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.flight_outlined,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
