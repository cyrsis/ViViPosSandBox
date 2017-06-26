{if order.destination_prefix == 1211 || order.destination_prefix == 1212 || order.destination_prefix == 1221 || order.destination_prefix == 1222 || order.destination_prefix == 2211 || order.destination_prefix == 2212 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
{if hasLinkedItems}
[&INIT]
{eval}
  sequence = order.seq.toString();
  if (sequence == null) {
    sequence = '';
  }
  else {
    sequence = sequence.substr(-3);
  }
  count = 0;
  total = 0;
  printObj = {};

  for( i=0; i<order.display_sequences.length; i++){
        if(order.display_sequences[i].type=='item'){
            printObj[order.display_sequences[i].index]= order.items[order.display_sequences[i].index];
            printObj[order.display_sequences[i].index].child = {};
        }
        if(order.display_sequences[i].type=='setitem')
             printObj[order.display_sequences[i].parent_index].child[order.display_sequences[i].index] = order.items[order.display_sequences[i].index];
  }

  for (itemId in printObj) {
        if(order.items[itemId].linked)
            total += order.items[itemId].current_qty;
  }
{/eval}
{for item in printObj}
{if item.linked}
{eval}
  table_name = order.table_no || '';
  tablesByNo = GeckoJS.Session.get('tablesByNo');
  if (tablesByNo) {
    table = tablesByNo[order.table_no];
    if (table) {
      table_name = table.table_name;
    }
  }
  condStr = '';
  condiments = item.condiments;
  if (condiments != null) {
    condStr = GeckoJS.BaseObject.getKeys(condiments).join(';');
  }
  if (defined(item.alt_name1) && item.alt_name1 != '') {
    name = item.alt_name1;
  }
  else {
    name = item.name;
  } 

  itemLen = new Array();

    for (var i = 0; i < item.current_qty; i++) {
        itemLen.push(i);
    }
{/eval}
{for index in itemLen}
{eval}
  header = '第 '+ ++count+' 項/共 '+total+' 項';
{/eval}
[&QSON]${'出 菜 單'|center:21}[&QSOFF]


{if store.state != ''}
[&QSON]${order.destination}單號:${sequence|tail:2|left:3}${'-' + count|left:7}[&QSOFF]
{else}
[&QSON]${order.destination}單號:${sequence|tail:3|left:3}${'-' + count|left:7}[&QSOFF]
{/if}
{if order.check_no != ''}
[&QSON]取餐號碼:${order.check_no}[&QSOFF]
{/if}
[&QSON]{if order.table_name != ''}桌名:${table_name|left:5}{/if}[&QSOFF][&DHON]日期:${new Date().toLocaleFormat('%m/%d')|left:6} 時間:${new Date().toLocaleFormat('%H:%M')}[&DHOFF]
------------------------------------------
[&QSON]${item.name|left:18}${'x 1'|right:3}[&QSOFF]
{if condStr != ''}
[&DHON] ●${condStr|left:18}[&DHOFF]

{/if}
{for child in item.child}
{eval}
  childcondStr = '';
  childcondiments = child.condiments;
  if (childcondiments != '') {
    condStr = GeckoJS.BaseObject.getKeys(childcondiments).join(';');
  }
  if (child.alt_name1 != '') {
    childname = child.alt_name1;
  }
  else {
    childname = child.name;
  }
{/eval}
[&QSON] →${childname|left:15}${'x 1'|right:3}[&QSOFF]

{if condStr != ''}
[&DHON] ●${condStr|left:18}[&DHOFF]

{/if}
{/for}
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/for}
{/if}
{/for}
{/if}
{/if}