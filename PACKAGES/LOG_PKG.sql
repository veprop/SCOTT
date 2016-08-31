--------------------------------------------------------
--  DDL for Package LOG_PKG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "SCOTT"."LOG_PKG" 
AS

--- Logging
   c_logging_context_name constant varchar2(30):='APP_CONTEXT';
   c_LOG_LEVEL_ATTRIBUTE  constant varchar2(30) := 'LOGLEVEL';
   c_TYPE_LOG_ATTRIBUTE constant varchar2(30) := 'TYPELOG';


-- level :
   LOG_LEVEL_DEBUG     constant number        :=   8;
   LOG_LEVEL_ERROR     constant number        :=   4;
   LOG_LEVEL_API       constant number        :=   2;
   LOG_LEVEL_INFO      constant number        :=   1;
   LOG_LEVEL_ALL       constant number        :=  63; --must be updated ...!!!

   LOG_LEVEL_DEFAULT    constant number       := LOG_LEVEL_ERROR + LOG_LEVEL_API;

--zalogovani debug vyjimky do LOGu
procedure debug_message
(
    p_Typ_Modul in EVENT_LOG.typ_modulu%type default 'DB',   --oznaceni typu modulu
    p_modul IN EVENT_LOG.modul%type default null, --puvodce vyjimky (modul)
    p_BusinessID in EVENT_LOG.businessid%type default null,   --identifikator dokladu, zadosti atd.
    p_message in EVENT_LOG.text_log%type  --debug hlaska pro logovani
);

--zalogovani info zpravy do LOGu
procedure info_message
(
    p_Typ_Modul in EVENT_LOG.typ_modulu%type default 'DB',   --oznaceni typu modulu
    p_modul IN EVENT_LOG.modul%type default null,
    p_BusinessID in EVENT_LOG.businessid%type default null,   --identifikator dokladu, zadosti atd.
    p_message in EVENT_LOG.text_log%type  --debug hlaska pro logovani
);

--zalogovani API message do LOGu
procedure api_message
(
    p_Typ_Modul in EVENT_LOG.typ_modulu%type default 'DB',    --oznaceni typu modulu
    p_modul IN EVENT_LOG.modul%type default null,
    p_BusinessID in EVENT_LOG.businessid%type default null,   --identifikator dokladu, zadosti atd.
    p_message in EVENT_LOG.text_log%type                      --debug hlaska pro logovani
);

--zalogovani chybove zpravy
procedure error_message
(
    p_Typ_Modul in EVENT_LOG.typ_modulu%type default 'DB',   --oznaceni typu modulu
    p_modul IN EVENT_LOG.modul%type default null,
    p_BusinessID in EVENT_LOG.businessid%type default null,   --identifikator dokladu, zadosti atd.
    p_message in EVENT_LOG.text_log%type default null  --debug hlaska pro logovani
);

function GetLoggingLevel return number;

function isloglevelDebug    return boolean;

function isloglevelInfo     return boolean;

function isloglevelAPI      return boolean;

procedure SetLogLevelMask(p_clientID    IN log_common_pkg.t_CLIENT_IDENTIFIER default null,
                          p_mask        IN number default LOG_LEVEL_INFO
                         );


function SetSessionIdentifier(p_clientID in log_common_pkg.t_CLIENT_IDENTIFIER default null) return varchar2;

function GetVersion
return varchar2;
PRAGMA RESTRICT_REFERENCES (GetVersion, RNDS, WNDS, WNPS);


procedure SetBusinessID(p_businessid in varchar2);

procedure SetLogSessionAttribute(
                          p_attribute    in VARCHAR2,
                          p_value        IN VARCHAR2,
                          p_clientID    IN log_common_pkg.t_CLIENT_IDENTIFIER default null
                         );

procedure SetLogParameter(p_parameter in parameters.PARAMETER%type,
     p_value in parameters.VALUE%type,
     p_app_name in parameters.APP_NAME%type default user
    );

END LOG_PKG;

/
