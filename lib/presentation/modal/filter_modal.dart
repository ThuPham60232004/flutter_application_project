import 'package:flutter/material.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  double _salaryValue = 50;
  bool _isFresherSelected = false;
  bool _isPartTimeSelected = true;
  bool _isFullTimeSelected = false;
  bool _isTechnologySelected = false;
  bool _isDesignSelected = false;
  bool _isMarketingSelected = false;
  String _selectedCity = ''; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Filter",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: Colors.black),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level Selection
            Text("Level", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FilterButton(
                  label: "Fresher",
                  isSelected: _isFresherSelected,
                  onTap: () => setState(() {
                    _isFresherSelected = !_isFresherSelected;
                  }),
                ),
                _FilterButton(
                  label: "Part-time",
                  isSelected: _isPartTimeSelected,
                  onTap: () => setState(() {
                    _isPartTimeSelected = !_isPartTimeSelected;
                  }),
                ),
                _FilterButton(
                  label: "Full-time",
                  isSelected: _isFullTimeSelected,
                  onTap: () => setState(() {
                    _isFullTimeSelected = !_isFullTimeSelected;
                  }),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Salary Range
            Text("Salary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("0 VND"),
                Text("100.000.000 VND"),
              ],
            ),
            Slider(
              value: _salaryValue,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  _salaryValue = value;
                });
              },
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.grey.shade300,
            ),
            SizedBox(height: 20),
            Text("Industry", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Search industry",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                _CheckboxTile(
                  label: "Technology",
                  value: _isTechnologySelected,
                  onChanged: (value) {
                    setState(() {
                      _isTechnologySelected = value!;
                    });
                  },
                ),
                _CheckboxTile(
                  label: "Design",
                  value: _isDesignSelected,
                  onChanged: (value) {
                    setState(() {
                      _isDesignSelected = value!;
                    });
                  },
                ),
                _CheckboxTile(
                  label: "Marketing",
                  value: _isMarketingSelected,
                  onChanged: (value) {
                    setState(() {
                      _isMarketingSelected = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            Text("City", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                _FilterButton(
                  label: "TPHCM",
                  isSelected: _selectedCity == 'TPHCM',
                  onTap: () {
                    setState(() {
                      _selectedCity = 'TPHCM'; 
                    });
                  },
                ),
                _FilterButton(
                  label: "HÀ NỘI",
                  isSelected: _selectedCity == 'HÀ NỘI',
                  onTap: () {
                    setState(() {
                      _selectedCity = 'HÀ NỘI';
                    });
                  },
                ),
                _FilterButton(
                  label: "ĐÀ NẴNG",
                  isSelected: _selectedCity == 'ĐÀ NẴNG',
                  onTap: () {
                    setState(() {
                      _selectedCity = 'ĐÀ NẴNG';
                    });
                  },
                ),
              ],
            ),
            Spacer(),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isFresherSelected = false;
                      _isPartTimeSelected = true;
                      _isFullTimeSelected = false;
                      _salaryValue = 50;
                      _isTechnologySelected = false;
                      _isDesignSelected = false;
                      _isMarketingSelected = false;
                      _selectedCity = '';  // Reset lại thành phố
                    });
                  },
                  child: Text(
                    "Reset filter",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Text(
                    "Apply",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blueAccent : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _CheckboxTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _CheckboxTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
