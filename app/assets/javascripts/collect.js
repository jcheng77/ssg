$(document).ready(function () {
  $('#bookmarklet_container #collect-item').click(function () {
    if ($('#item_category').find("option:selected").text() == '请选择') {
      alert('请选择商品分类');
      return false;
    };
    if ($('#desc').val().length == 0) {
      alert('请输入收藏评论');
      return false;
    }
  });
});
