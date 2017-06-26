{if order.destination_prefix == 1211 || order.destination_prefix == 1212 || order.destination_prefix == 1221 || order.destination_prefix == 1222 || order.destination_prefix == 2211 || order.destination_prefix == 2212 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
{if hasLinkedItems}
{eval}
  sequence = order.seq.toString();
  if (sequence == null)
    sequence = '';

  count = 0;
  total = 0;
  printObj = {};

for(index in order.items){
   item = order.items[index];
   if(item.linked){

       if(item.condiments != null){

            printObj[item.index] = item;
       }else{

           if(item.id in printObj)
               printObj[item.id].current_qty += item.current_qty
           else
               printObj[item.id] = item;
       }
   }
}

GeckoJS.BaseObject.log(GeckoJS.BaseObject.dump(printObj));

for (itemId in printObj) {
    total ++;
  }
{/eval}
{if total < 1}
[&INIT]
{/if}
{for item in printObj}
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
{eval}
  header = '第 '+ ++count+' 項/共 '+total+' 項';
{/eval}
{if order.destination == '內用'}
[&OSON]單${sequence|tail:3} ${'桌' + table_name|left:7}[&OSOFF]
{elseif order.destination == '桌外帶'}
[&OSON]單${sequence|tail:3} ${'桌' + table_name}外帶[&OSOFF]
{elseif order.destination == '外用'}
[&OSON]單${sequence|tail:3} ${'外用'}[&OSOFF]
{elseif order.destination == '外帶'}
[&OSON]單${sequence|tail:3} ${'外帶'}[&OSOFF]
{else}
[&OSON]單${sequence|tail:3}  ${order.destination}[&OSOFF]
{/if}
{if order.check_no != ''}
[&QSON]取餐號碼:${order.check_no}[&QSOFF]
{/if}
------------------------------------------
[&OSON]${name + 'x' + item.current_qty|right:16}[&OSOFF]
{if condStr != ''}
[&QSON] ${condStr|right:18}[&QSOFF]
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/for}    
{/if}
{/if}