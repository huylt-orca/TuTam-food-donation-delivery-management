import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/statement_list.dart';
import 'package:food_donation_delivery_app/services/stock_updated_history_service.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';



class StatementsScreen extends StatefulWidget {
  final int type; // 0: Branch, 1: Charity, 2: Activity, 3: User
  final String id;
  const StatementsScreen({
    super.key,
    required this.type,
    required this.id
    });

  @override
  State<StatementsScreen> createState() => _StatementsScreenState();
}

class _StatementsScreenState extends State<StatementsScreen> {
  
  List<StatementList> _statements = List.empty(growable: true);
    final _scrollController = ScrollController();
  final TextEditingController _txtDateFrom = TextEditingController();
  final TextEditingController _txtDateTo = TextEditingController();
  
  
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  int _page = 1;
  String _txtMessage = '';
  bool _isLoading = true;

  void _getData()async{
    StockUpdatedHistoryService.fetchStatementList(id: widget.id, typeAPI: widget.type)
    .then((value) {
        _statements = value;
      setState(() {
        _isLoading = false;
      });
    },);
  }

  void _runFilter(){
    setState(() {
      _isLoading = true;
    });
    StockUpdatedHistoryService.fetchStatementList(
      id: widget.id,
      typeAPI: widget.type,
      startDate: _selectedDateFrom == null ? '' : _selectedDateFrom.toString(),
      endDate: _selectedDateTo == null ? '' : _selectedDateTo.toString()
    ).then((value) {
        _statements = value;
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget switchDataBaseRole (StatementList statement){
    String textItem = '${statement.type == 'IMPORT' ? '+' : '-' }${statement.quantity} ${statement.unit} ${statement.name}${statement.attributeValues.join('-')}';
    switch(widget.type){
      case 0: 
      String newText = '';
      if (statement.type == 'IMPORT'){
        if(statement.donorName.isEmpty){
          newText = ', ${statement.note}';
        } else {
          newText = '${statement.donorName.isEmpty ? '' : ', quyên góp từ ${statement.donorName}'}${statement.activityName.isEmpty ? '' : ', thông qua hoạt động ${statement.activityName}'}';
        }
      } else {
        if (statement.deliveryPoint.isEmpty){
          newText = ', ${statement.note}';
        } else {
          newText = ', quyên góp cho ${statement.deliveryPoint}${statement.donorName.isEmpty ? '' : ', được quyên góp bởi ${statement.donorName}'}${statement.activityName.isEmpty ? '' : ', thông qua hoạt động ${statement.activityName}' }';
        }
      }
           return ContentStatement(
            color: statement.type == 'IMPORT' ? Colors.green : Colors.red,
            createdDate: statement.createdDate,
            textItem: textItem,
            text: newText,
           );
      case 1:
      textItem = '${statement.type != 'IMPORT' ? '+' : '-' }${statement.quantity} ${statement.unit} ${statement.name}${statement.attributeValues.join('-')}';
          return ContentStatement(
            color: statement.type != 'IMPORT' ? Colors.green : Colors.red,
            createdDate: statement.createdDate,
            textItem: textItem,
            text: ', nhận từ ${statement.pickUpPoint}${statement.donorName.isEmpty ? '' : ', được quyên góp bởi ${statement.donorName}'}${statement.activityName.isEmpty ? '' : ', thông qua hoạt động ${statement.activityName}' }',
           );
      case 2:
    return ContentStatement(
            color: statement.type == 'IMPORT' ? Colors.green : Colors.red,
            createdDate: statement.createdDate,
            textItem: textItem,
            text: statement.type == 'IMPORT' ? 
            '${statement.donorName.isEmpty ? '' : ', quyên góp từ ${statement.donorName}'}, cho ${statement.pickUpPoint}' 
            : statement.deliveryPoint.isEmpty ? statement.note  : '${statement.donorName.isEmpty ? '' : ', quyên góp từ ${statement.donorName}'}, thông qua ${statement.pickUpPoint}, giao cho ${statement.deliveryPoint}',
           );
    case 3:
      return ContentStatement(
            color: statement.type == 'IMPORT' ? Colors.green : Colors.red,
            createdDate: statement.createdDate,
            textItem: textItem,
            text: ', quyên góp cho ${statement.pickUpPoint}${statement.activityName.isEmpty ? '' : ', thông qua hoạt động ${statement.activityName}' }' ,
           );
    default:
      return const SizedBox();

    }

  }

  @override
  void initState() {
    super.initState();
    
     _scrollController.addListener(_scrollListener);
    _getData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _page++;
      StockUpdatedHistoryService.fetchStatementList(
        id: widget.id,
        page: _page,
        startDate: _selectedDateFrom == null ? '' : _selectedDateFrom.toString(),
      endDate: _selectedDateTo == null ? '' : _selectedDateTo.toString()
      ).then((data) {
        setState(() {
          _statements.addAll(data);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách ủng hộ'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: TextFormField(
                                    controller: _txtDateFrom,
                                    keyboardType: TextInputType.none,
                                    decoration: const InputDecoration(
                                      label: Text("Từ ngày"),
                                      suffixIcon: Icon(Icons.date_range),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)
                                    ),
                                    onTap: () async {
                                      final DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _selectedDateFrom ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null &&
                                          picked != _selectedDateFrom) {
                                        setState(() {
                                          _selectedDateFrom = picked;
                                          _txtDateFrom.text =
                                              Utils.converDate(picked.toString());
                                        });
                      
                                        if (_txtDateFrom.text != '' &&
                                            _txtDateTo.text != '') {
                                          if (_selectedDateTo!
                                              .isBefore(_selectedDateFrom!)) {
                                            setState(() {
                                              _txtMessage = 'Ngày bắt đầu không thể sau ngày kết thúc';
                                            });
                                          }else{
                                            _txtMessage = '';
                                            _runFilter();
                                          }
                                        }else {
                                          _runFilter();
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: TextFormField(
                                    controller: _txtDateTo,
                                    keyboardType: TextInputType.none,
                                    decoration: const InputDecoration(
                                      label: Text("Đến ngày"),
                                      suffixIcon: Icon(Icons.date_range),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)
                                    ),
                                    onTap: () async {
                                      final DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _selectedDateTo ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null &&
                                          picked != _selectedDateTo) {
                                        setState(() {
                                          _selectedDateTo = picked;
                                          _txtDateTo.text =
                                              Utils.converDate(picked.toString());
                                        });
                      
                                        if (_txtDateFrom.text != '' &&
                                            _txtDateTo.text != '') {
                                          if (_selectedDateTo!
                                              .isBefore(_selectedDateFrom!)) {
                                            setState(() {
                                              _txtMessage = 'Ngày kết thúc không thể trước ngày bắt đầu';
                                            });
                                          } else{
                                            _txtMessage = '';
                                            _runFilter();
                                          }
                                        } else {
                                          _runFilter();
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              _txtMessage.isEmpty ? const SizedBox() :
              Text(_txtMessage,
              style: const TextStyle(
                color: Colors.red
              ),
              ),
              const SizedBox(
                height: 5,
              ),
              (_statements.isEmpty && !_isLoading) ?
                  const Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Icon(
                            Icons.search,
                            size: 100,
                            color: Colors.grey,
                          ),
                          Text(
                            'Chưa có người quyên góp',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
              : SizedBox(
                height: MediaQuery.of(context).size.height - 190,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _isLoading ? 6 : _statements.length,
                  itemBuilder: (context, index) {
                    return 
                    _isLoading ?
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(4.0),
                      color:  AppTheme.greyBackground,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget.rectangular(height: 20, width: MediaQuery.of(context).size.width * 0.8,),
                          const SizedBox(height: 8,),
                          ShimmerWidget.rectangular(height: 20, width: MediaQuery.of(context).size.width * 0.3,),
                        ],
                      ),
                    )
                    : Container(
                      color: index.isEven ? Colors.white : AppTheme.greyBackground,
                      child: switchDataBaseRole(_statements[index])
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentStatement extends StatelessWidget {
  final String textItem;
  final Color color;
  final String createdDate;
  final String text;

  const ContentStatement({
    super.key,
    required this.color,
    required this.textItem,
    required this.createdDate,
    required this.text
  });


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [

              TextSpan(
                  text: textItem,
                  style:  TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600)),
              TextSpan(
                text: text,
              ),

              // TextSpan(
              //     text: '${_statement.type == 'IMPORT' ? '+' : '-' }${_statement.quantity} ${_statement.unit} ${_statement.name} ${_statement.attributeValues.join('-')}',
              //     style: const TextStyle(
              //         color: Colors.green,
              //         fontWeight: FontWeight.w600)),
              // TextSpan(
              //   text: ', quyên góp ${_statement.type == 'IMPORT' ? 'từ' : 'cho' } ',
              // ),
            
              // _statement.activityName.isEmpty ? const TextSpan() :
              // TextSpan(
              //     text: _statement.type == 'IMPORT' ? _statement.pickUpPoint : _statement.deliveryPoint,
              //     style: const TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w600)),
              //         TextSpan(
              //   text: ', ${_statement.type == 'IMPORT' ? 'cho' : 'từ' } hoạt động ${_statement.activityName}',
              // ),
            ]),
      ),
      subtitle:  Text('● ${Utils.converDate(createdDate)}', style: const TextStyle(fontSize: 12),),
    );
  }
}


