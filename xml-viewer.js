(function ( $ ) {
    var xslDoc = $.ajax('xml-viewer.xsl',
        {
            async:false,
            dataType:'xml'
        }
    ).responseXML;

    $(document).on('click','.xmlviewer.expander',function(){
        $this = $(this);
        $parent = $this.parent();
        $parent.toggleClass('expander-open expander-closed');
        if($this.text()=='-')
            $this.text('+');
        else
            $this.text('-');
    });

    $.fn.xmlViewer = function(xmlUri) {
        var html;
        var $html;
        var xmlDoc = $.ajax(
            xmlUri,
            {
                async:false,
                dataType:'xml'
            }
        ).responseXML;

        // code for IE
        if (window.ActiveXObject || "ActiveXObject" in window)
        {
            if(xmlDoc.transformNode)// until IE8 (inclusive)
                html = xmlDoc.transformNode(xslDoc);
            else{// IE9+
                var _xslt = new ActiveXObject("Msxml2.XSLTemplate");
                var _xslDoc = new ActiveXObject("Msxml2.FreeThreadedDOMDocument");
                _xslDoc.loadXML((new XMLSerializer()).serializeToString(xslDoc));
                _xslt.stylesheet = _xslDoc;
                var _xslProc = _xslt.createProcessor();
                _xslProc.input = xmlDoc;
                _xslProc.transform();
                html = _xslProc.output;
            }
        }
        // code for Chrome, Firefox, Opera, etc.
        else if (document.implementation && document.implementation.createDocument)
        {
            var _xsltProcessor = new XSLTProcessor();
            _xsltProcessor.importStylesheet(xslDoc);
            html = _xsltProcessor.transformToFragment(xmlDoc, document);

        }

        $html =$('<div class="xmlviewer">').append($(html));

        return this.each(function() {
            $(this).empty().append($html);
        });
    };
}( jQuery ));
