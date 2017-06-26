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
GREUtils.log(GeckoJS.BaseObject.dump(printObj));
{/eval}

{for item in printObj}
{if item.linked}
{eval}
  conds = GeckoJS.BaseObject.getKeys(item.condiments);
  if (defined(item.alt_name1) && item.alt_name1 != '') {
    name = item.alt_name1;
  }
  else {
    name = item.name;
  }

{/eval}
{eval}
count += item.current_qty;
header = count + '/' + total;
{/eval}
{if item.current_qty >= 0 || item.current_qty == 0}
{if order.destination == '外賣' || order.destination == '外送' }
[0x1B][0x72][0x01]
[&QSON]${'外:' + order.check_no }  ${header}[&QSOFF]
[0x1B][0x72][0x00]
{else}
[&QSON]${'台:' + order.table_name}
${'單:'+ order.seq}  ${header}[&QSOFF]
{/if}
[&QSON]${'時間:' + new Date().toLocaleFormat('%H:%M')|left:18}[&QSOFF]
[&QSON]${'服務人員:'|left:10}${order.service_clerk_displayname|left:16}[&QSOFF]
[&QSON]$${'人數:'}${order.no_of_customers}[&QSOFF]
-------------------------------------
[&CR]
[&QSON]${name}[&QSOFF] [&QSON]${'X'+item.current_qty|right:3}[&QSOFF]
{if item.condiments != null}
{for cond in conds}
[&QSON]  ${cond}X${item.condiments[cond].current_qty}[&QSOFF]
{/for}
{/if}
{for child in item.child}
{eval}
  childcondStr = '';
  childcondiments = child.condiments;
  if (childcondiments != null) {
    conds= GeckoJS.BaseObject.getKeys(childcondiments);
  }
  if (defined(child.alt_name1) && child.alt_name1 != '') {
    childname = child.alt_name1;
  }
  else {
    childname = child.name;
  }
{/eval}
[&QSON]    ${childname|left:10}${childname.current_qty}[&QSOFF]
{for cond in conds}
[&QSON]    ${cond}X${childcondiments[cond].current_qty}[&QSOFF]
{/for}
{/for}
[&CR]
[&CR]
[&CR]
{if order.destination == '外賣' || order.destination == '外送'}
[0x1B][0x72][0x01]
[&QSON]${'外賣:' + order.check_no|center} [&QSOFF]
[0x1B][0x72][0x00]
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{/if}
{/if}
{/for}
[&CR]
[&CR]
{/if}
