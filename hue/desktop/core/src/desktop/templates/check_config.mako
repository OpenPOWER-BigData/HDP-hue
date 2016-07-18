## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
<%!
from desktop.lib.conf import BoundConfig
from desktop.views import commonheader, commonfooter
from django.utils.translation import ugettext as _
%>

<%namespace name="layout" file="about_layout.mako" />

<%def name="error_page(conf_dir, error_list)">
    ${_('Configuration files located in')} <code>${conf_dir}</code>
    <br/><br/>
    % if error_list:
      <h2>${_('Potential misconfiguration detected. Fix and restart Hue.')}</h2>
      <br/>
        <table class="table table-striped">
      % for confvar, error in error_list:
        <tr>
            <td width="5%">
                <code>
                % if isinstance(confvar, str):
                  ${confvar | n}
                % else:
                  ${confvar.get_fully_qualifying_key()}
                % endif
              </code>
            </td>
            <td>
              ## Doesn't make sense to print the value of a BoundContainer
              % if type(confvar) is BoundConfig:
                ${_('Current value:')} <code>${confvar.get()}</code><br/>
              % endif
              ${error | n}
            </td>
        </tr>
      % endfor
    </table>
    % else:
      <h2>${_('All OK. Configuration check passed.')}</h2>
    % endif
</%def>

<%def name="container()">
${ commonheader(_('About'), "about", user, "100px") | n,unicode }

${ layout.menubar(section='check_config') }

<div class="container-fluid">
    <div class="spinner" style="text-align: center;">
    <!--[if !IE]><!--><i class="icon-spinner icon-spin" style="font-size: 60px;"></i><!--<![endif]-->
    <!--[if IE]><img src="/static/art/spinner.gif" width="16" height="16"/><![endif]-->
    </div>
</div>
<script type="text/javascript">
  $.get("${ url('desktop.views.check_config') }", function(response) {
    $(".spinner").replaceWith(response);
  }).fail(function() { $.jHueNotify.error('${ _("Check config failed: ")}'); });
</script>

${ commonfooter(messages) | n,unicode }
</%def>

% if not show_error:
  ${container()}
% else:
  ${error_page(conf_dir, error_list)}
% endif