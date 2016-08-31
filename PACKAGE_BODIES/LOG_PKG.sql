--------------------------------------------------------
--  DDL for Package Body LOG_PKG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SCOTT"."LOG_PKG" 
AS
--pridej parametr

   --oznaceni verze pro LOG
   c_version constant varchar2(10):='1.0.0';

procedure debug_message
(
    p_Typ_Modul in EVENT_LOG.typ_modulu%type default 'DB',   --oznaceni typu modulu
    p_modul IN EVENT_LOG.modul%type default null, --puvodce vyjimky (modul)
    p_BusinessID in EVENT_LOG.businessid%type default null,   --identifikator dokladu, zadosti atd.
    p_message in EVENT_LOG.text_log%type  --debug hlaska pro logovani
)
is
begin
  log_common_pkg.debug_message(p_typ_Modul, p_modul, p_BusinessID, p_message);
end;

--zalogovani info zpravy do LOGu
procedure info_message
(
    p_Typ_Modul in EVENT_LOG.typ_modulu%type default 'DB',   --oznaceni typu modulu
    p_modul IN EVENT_LOG.modul%type default null,
    p_BusinessID in EVENT_LOG.businessid%type default null,   --identifikator dokladu, zadosti atd.
    p_message in EVENT_LOG.text_log%type  --debug hlaska pro logovani
)
is
begin
  log_common_pkg.info_message(p_typ_modul, p_modul, p_BusinessID, p_message);
end;

--zalogovani API message do LOGu
procedure api_message
(
    p_Typ_Modul in EVENT_LOG.typ_modulu%type default 'DB',    --oznaceni typu modulu
    p_modul IN EVENT_LOG.modul%type default null,
    p_BusinessID in EVENT_LOG.businessid%type default null,   --identifikator dokladu, zadosti atd.
    p_message in EVENT_LOG.text_log%type                      --debug hlaska pro logovani
)
is
begin
  log_common_pkg.api_message(p_typ_modul, p_modul, p_businessID, p_message);
end;

--zalogovani chybove zpravy
procedure error_message
(
    p_Typ_Modul in EVENT_LOG.typ_modulu%type default 'DB',   --oznaceni typu modulu
    p_modul IN EVENT_LOG.modul%type default null,
    p_BusinessID in EVENT_LOG.businessid%type default null,   --identifikator dokladu, zadosti atd.
    p_message in EVENT_LOG.text_log%type default null  --debug hlaska pro logovani
)
is
begin
  log_common_pkg.error_message(p_typ_modul, p_modul, p_BusinessID, p_message);
end;

-- vrati aktualni log level
function GetLoggingLevel return number
is
begin
  return log_common_pkg.GetLoggingLevel;
end;

--Vrati true pokud je pro soucastnou session log level DEBUG
function isloglevelDebug    return boolean
is
begin
  return log_common_pkg.isLogLevelDebug;
end;

--Vrati true pokud je pro soucastnou session log level INFO
function isloglevelInfo     return boolean
is
begin
  return log_common_pkg.isLogLevelInfo;
end;

--Vrati true pokud je pro soucastnou session log level API
function isloglevelAPI      return boolean
is
begin
  return log_common_pkg.isLogLevelApi;
end;

procedure SetLogLevelMask(p_clientID    IN log_common_pkg.t_CLIENT_IDENTIFIER default null,
                          p_mask        IN number
                         )
is
begin
  log_common_pkg.SetLogLevelMask(p_clientID, p_mask);
end;


function SetSessionIdentifier(p_clientID in log_common_pkg.t_CLIENT_IDENTIFIER default null) return varchar2
is
begin
  return log_common_pkg.SetSessionIdentifier(p_clientID);
end;

--vraci verzi package
function GetVersion
return varchar2
is
begin
    return c_version;
end;


procedure SetLogSessionAttribute(
                          p_attribute    in VARCHAR2,
                          p_value        IN VARCHAR2,
                          p_clientID    IN log_common_pkg.t_CLIENT_IDENTIFIER default null
                         )
is
begin
  log_common_pkg.SetLogSessionAttribute(p_attribute, p_value, p_clientID);
end;


procedure SetLogParameter(p_parameter in parameters.PARAMETER%type,
                          p_value in parameters.VALUE%type,
                          p_app_name in parameters.APP_NAME%type default user
                         )
is
begin
  log_common_pkg.SetLogParameter(p_parameter, p_value, p_app_name);
end;

procedure SetBusinessID(p_businessid in varchar2)
is
begin
    log_common_pkg.setBusinessID(p_businessid);
end;

END LOG_PKG;

/
