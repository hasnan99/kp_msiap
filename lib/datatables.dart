import 'package:flutter/material.dart';
import 'package:kp_msiap/model/sheet.dart';

class tableasset extends StatefulWidget {
  const tableasset({Key? key}) : super(key: key);

  @override
  _tableasset createState() => _tableasset();
}

class _tableasset extends State<tableasset> {
  List<sheet> data = [];
  List<sheet> filteredData = []; // Data yang difilter berdasarkan pencarian
  bool isSearching = false;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  List<bool> columnVisibility = List.generate(12, (index) => true); // List boolean untuk melacak visibilitas setiap kolom

  @override
  void initState() {
    super.initState();
  }

  void _filterData(String query) {

  }

  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      filteredData.sort((a, b) {
        var aValue, bValue;
        switch (columnIndex) {
          case 0:
            aValue = a.nama_asset;
            bValue = b.nama_asset;
            break;
          case 1:
            aValue = a.jenis_asset;
            bValue = b.jenis_asset;
            break;
          case 2:
            aValue = a.kondisi;
            bValue = b.kondisi;
            break;
          case 3:
            aValue = a.status_pemakaian;
            bValue = b.status_pemakaian;
            break;
          case 4:
            aValue = a.utilisasi;
            bValue = b.utilisasi;
            break;
          case 5:
            aValue = a.tahun_perolehan;
            bValue = b.tahun_perolehan;
            break;
          case 6:
            aValue = a.umur_teknis;
            bValue = b.umur_teknis;
            break;
          case 7:
            aValue = a.sumber_dana;
            bValue = b.sumber_dana;
            break;
          case 8:
            aValue = a.nilai_perolehan;
            bValue = b.nilai_perolehan;
            break;
          case 9:
            aValue = a.nilai_buku;
            bValue = b.nilai_buku;
            break;
          case 10:
            aValue = a.rencana_optimisasi;
            bValue = b.rencana_optimisasi;
            break;
          case 11:
            aValue = a.lokasi;
            bValue = b.lokasi;
            break;
          default:
            aValue = a.nama_asset;
            bValue = b.nama_asset;
        }
        final comparison = aValue.compareTo(bValue);
        return ascending ? comparison : -comparison;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Asset'),
        backgroundColor: Colors.red,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: const Text('Menu'),
            ),
            ListTile(
              title: const Text('Sembunyikan Kolom'),
              onTap: () {
                Navigator.pop(context); // Tutup sidebar
                _showHideColumnDialog(context); // Tampilkan dialog untuk hide column
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    isSearching = value.isNotEmpty;
                    _filterData(value);
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Cari aset',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            PaginatedDataTable(
              columns: [
                DataColumn(
                    label: const Text("No")),
                if (columnVisibility[0])
                  DataColumn(
                    label: const Text('Nama Aset'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                if (columnVisibility[1])
                  DataColumn(
                    label: const Text('Jenis Aset'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                if (columnVisibility[2])
                  DataColumn(
                    label: const Text('Kondisi'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                if (columnVisibility[3])
                  DataColumn(
                    label: const Text('Status Pemakaian'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                if (columnVisibility[4])
                  DataColumn(
                    label: const Text('Utilisasi'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                if (columnVisibility[5])
                  DataColumn(
                    label: const Text('Tahun Perolehan'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                if (columnVisibility[6])
                  DataColumn(
                    label: const Text('Umur Teknis'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                if (columnVisibility[7])
                  DataColumn(
                    label: const Text('Sumber Dana'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                if (columnVisibility[8])
                  DataColumn(
                    label: const Text('Nilai Perolehan'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                if (columnVisibility[9])
                  DataColumn(
                    label: const Text('Nilai Buku'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                if (columnVisibility[10])
                  DataColumn(
                    label: const Text('Rencana Optimisasi'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                if (columnVisibility[11])
                  DataColumn(
                    label: const Text('Lokasi'),
                    onSort: (columnIndex, ascending) =>
                        _sortData(columnIndex, ascending),
                  ),
                DataColumn(
                    label: const Text("Gambar")),
              ],
              source: _AssetDataTableSource(filteredData, columnVisibility),
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              showCheckboxColumn: false,
              rowsPerPage: 10,
              onSelectAll: (isAllChecked) {},
            ),
          ],
        ),
      ),
    );
  }

  void _showHideColumnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hide Column'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CheckboxListTile(
                  title: const Text('Nama Aset'),
                  value: columnVisibility[0],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[0] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Jenis Aset'),
                  value: columnVisibility[1],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[1] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Kondisi'),
                  value: columnVisibility[2],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[2] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Status Pemakaian'),
                  value: columnVisibility[3],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[3] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Utilisasi'),
                  value: columnVisibility[4],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[4] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Tahun Perolehan'),
                  value: columnVisibility[5],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[5] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Umur Teknis'),
                  value: columnVisibility[6],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[6] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Sumber Dana'),
                  value: columnVisibility[7],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[7] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Nilai Perolehan'),
                  value: columnVisibility[8],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[8] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Nilai Buku'),
                  value: columnVisibility[9],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[9] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Rencana Optimisasi'),
                  value: columnVisibility[10],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[10] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Lokasi'),
                  value: columnVisibility[11],
                  onChanged: (bool? value) {
                    setState(() {
                      columnVisibility[11] = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


class _AssetDataTableSource extends DataTableSource {
  _AssetDataTableSource(this.data, this.columnVisibility);

  final List<sheet> data;
  final List<bool> columnVisibility;

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final sheet asset = data[index];
    final int no=index+1;
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(no.toString())),
        if (columnVisibility[0]) DataCell(Text(asset.nama_asset)),
        if (columnVisibility[1]) DataCell(Text(asset.jenis_asset??"")),
        if (columnVisibility[2]) DataCell(Text(asset.kondisi??"")),
        if (columnVisibility[3]) DataCell(Text(asset.status_pemakaian??"")),
        if (columnVisibility[4]) DataCell(Text(asset.utilisasi as String)),
        if (columnVisibility[5]) DataCell(Text(asset.tahun_perolehan as String)),
        if (columnVisibility[6]) DataCell(Text(asset.umur_teknis as String)),
        if (columnVisibility[7]) DataCell(Text(asset.sumber_dana??"")),
        if (columnVisibility[8]) DataCell(Text(asset.nilai_perolehan as String)),
        if (columnVisibility[9]) DataCell(Text(asset.nilai_buku as String)),
        if (columnVisibility[10]) DataCell(Text(asset.rencana_optimisasi??"")),
        if (columnVisibility[11]) DataCell(Text(asset.lokasi??"")),
        DataCell(Image.network(asset.gambar as String)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}




