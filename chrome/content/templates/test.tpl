[&INIT]
{eval}
  clerk = order.proceeds_clerk_displayname;
  if (clerk == null || clerk == '') {
    clerk = order.service_clerk_displayname;
  }
  if (clerk == null) {
    clerk = '';
  }
  var sequenceTracksDate = GeckoJS.Configure.read('vivipos.fec.settings.SequenceTracksSalePeriod');
  var sequenceLength = GeckoJS.Configure.read('vivipos.fec.settings.SequenceNumberLength');
  sequence = order.seq.toString();
  if (sequence == null) {
    sequence = '';
  }
  else if (sequenceTracksDate) {
    sequence = sequence.substr(-sequenceLength);
  }
  now = new Date();
  today = now.toLocaleFormat('%Y/%m/%d');
  time = now.toLocaleFormat('%H:%M');
  hour = now.toLocaleFormat('%H');
  terminal = order.terminal_no;
  index = 0;
  count = 0;
  memos = [];
  alert('店名:' + store.name + '    訂單類型：' + order.destination + '   找零:' + (0 - order.remain))
{/eval}
{eval}
  table_name = order.table_no || '';
  tablesByNo = GeckoJS.Session.get('tablesByNo');
  if (tablesByNo) {
    table = tablesByNo[order.table_no];
    if (table) {
      table_name = table.table_name;
    }
  }
  payment_types = [];
  payment_types_str = '';
  for (key in order.trans_payments) {
    payment = order.trans_payments[key];
    if (payment.name == 'creditcard') display_name = '信用卡';
    else if (payment.name == 'giftcard') display_name = '禮券';
    else if (payment.name == 'coupon') display_name = '折價券';
    else if (payment.name == 'check') display_name = '支票';
    else display_name = '現金';

    payment_types.push({
      name: payment.name,
      memo1: payment.memo1,
      display_name: display_name,
      amount: payment.amount
    });

    payment_types_str += display_name + ',';
  }
{/eval}
{eval} 
  destination_prefix = order.destination_prefix;
{/eval}
    ★訂單內容★
訂單登打日期:${today} 
訂單登打時間:${time}
訂單類型:${order.destination}
訂單序號:${order.seq} 
打單人員帳號:${order.proceeds_clerk_displayname}
    ▼店家資料▼
店名:${store.name|left:12}  分店名:${store.branch}
分店代碼:${store.branch_id|left:8}  機號:${store.terminal_no}
聯絡人:${store.contact}
電話1:${store.telephone1|left:11}  電話2:${store.telephone2}
地址1:${store.address1|left:11}  地址2:${store.address2}
國家:${store.country|left:12}  省:${store.state}
縣:${store.county|left:14}  市:${store.city}
郵遞區號:${store.zip}
傳真:${store.fax|left:12}  mail:${store.email}
備註:${store.note}
--------------------------
    ◆產品內容◆
{for item in order.display_sequences}
{if item.type == 'item'}
{eval}
  condStr = '';
  itemTrans = order.items[item.index];
  condiments = itemTrans.condiments;
  count += parseInt(itemTrans.current_qty);
  if (condiments != null) {
    condStr = GeckoJS.BaseObject.getKeys(condiments).join(';');
  }
{/eval}
${itemTrans.name}  部門:${itemTrans.cate_name}
數量:${itemTrans.current_qty}  單位:${itemTrans.sale_unit}
產品編號:${itemTrans.no}
條碼編號:${itemTrans.barcode}
剩餘庫存:${itemTrans.maintain_stock}  安全庫存:${itemTrans.low_stock}
單價:${itemTrans.current_price}  小計:${itemTrans.current_subtotal}
內含稅金額:${itemTrans.included_tax_subtotal} 未稅額:${itemTrans.taxable}
**************************
{/if}
{/for}
{if customer != null}
    ▲會員資訊▲
會員姓名:${customer.name}
會員編號:${customer.customer_id}
會員電話:${customer.telephone}
會員生日:${customer.dob}
公司名稱:${customer.company}
電子郵件:${customer.email}
建立時間:${customer.created}
{/if}
離場時間: ${(hour - order.destination_prefix)}${':' + now.toLocaleFormat('%M')}
(訂單類型註記輸入負向數字即可計算，單位小時)
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]