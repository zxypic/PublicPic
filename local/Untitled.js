/**
 * 时间戳 转换为 yyyy-MM-dd HH:mm:ss
 * @param {number} timestamp 
 * @param {string} format 
 */
function timestampToDateTime(timestamp = Date.now(), format = 'yyyy-MM-dd HH:mm:ss') {
    if (isNaN(timestamp)) {
        return '';
    }

   if (format.length < 4 || 'yyyy-MM-dd HH:mm:ss'.indexOf(format) !== 0) {
        return '';
    }

    const date = new Date(Number(timestamp));

    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    const hour = date.getHours();
    const minute = date.getMinutes();
    const second = date.getSeconds();

    return format.replace('yyyy', year)
    .replace('MM', month > 9 ? month : `0${month}`)
    .replace('dd', day > 9 ? day : `0${day}`)
    .replace('HH', hour > 9 ? hour :`0${hour}`)
    .replace('mm', minute > 9 ? minute : `0${minute}`)
    .replace('ss', second > 9 ? second : `0${second}`);
} 

var time2 = timestampToDateTime();  
console.log(time2)