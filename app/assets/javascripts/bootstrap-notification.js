/* ============================================================
 * bootstrap-dropdown.js v2.1.1
 * http://twitter.github.com/bootstrap/javascript.html#dropdowns
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */


!function ($) {

  "use strict"; // jshint ;_;

  $(document).ready(function(){
      $('#notification-badge').dropdown();
      $.ajax(
              {
                url: '/users/recent_notifications',
                type: 'GET',
                dataType: 'json',
                success: function(data){
                  $('#notification-badge').html(data.length);
                  $('#notification-badge').css('display',data.length > 0 ? 'block' : 'none');

                  var content = [];
                  content.push('<li><span class="notification-new">新消息 (', data.length,') - </span></li>');
                  content.push('<li class="divider"></li>')
                  var nfs = data.notifications;
                  if(nfs && nfs.length > 0){
                    for (var i = 0; i < nfs.length; i++) {
                      var nf = nfs[i];
                      content.push('<li><a href="', nf.url, '">', nf.msg, '</a></li>');
                    }
                  } else {
                    content.push('<li>没有最新消息</li>');
                  }
                  content.push('<li class="divider"></li>')
                  content.push('<li><a href="/users/all_notifications" class="notification-all">查看所有消息...</a></li>');
                  $('#notification-panel').html(content.join(''));
                },
                error: function() {
                  // alert('error occured!');
                }  
              }
            );
  })

}(window.jQuery);