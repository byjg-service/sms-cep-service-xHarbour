//------------------------------------------------------------------------------
// Integracao byjg.com.br SMS xHarbour
// Alexandre Oliveira
// alexandre.oliveira@awsinformatica.com.br
//------------------------------------------------------------------------------

FUNCTION EnviaSMS()
   LOCAL oUrl
   LOCAL oPagina
   LOCAL cUrl
   LOCAL cPost
   LOCAL cBuf

   // Variaveis para post
   LOCAL cMensagem := "TESTE-XHARBOUR-SMS-BYJG"
   LOCAL cDDD      := "15"
   LOCAL cCelular  := "81434142"

   // Parametros da conta no ByJG
   LOCAL cUsuario := "nome_da_conta_byjg"
   LOCAL cSenha   := "senha_da_conta_byjg"

   cUrl := "http://www.byjg.com.br/site/webservice.php/ws/sms"

   cPost := "?httpmethod=enviarsms"
   cPost := cPost + "&ddd=" + cDDD
   cPost := cPost + "&celular=" + cCelular
   cPost := cPost + "&mensagem=" + cMensagem
   cPost := cPost + "&usuario=" + cUsuario
   cPost := cPost + "&senha=" + cSenha

   oUrl:=TUrl():New( cUrl )
   oPagina := TipClientHttp():New( oUrl , .T. )
   oPagina:nConnTimeout := 20000

   IF oPagina:Open( cUrl+cPost )

      cBuf := oPagina:ReadAll()

      Alert(cBuf,"Mensagem de retorno")

   ELSE
      Alert("Verifique acesso a internet!")

   ENDIF

RETURN NIL
