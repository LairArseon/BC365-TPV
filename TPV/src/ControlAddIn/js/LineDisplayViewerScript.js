Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ViewerReady', '');

CurrentLoadedElement = null;
SourceElement = null;

class LoadedElement {
    elementSource = null;
    fields = null;
    maskedFields = null;

    constructor(ElementSource, Element) {
        this.elementSource = ElementSource;
        this.fields = Element;
    }

    MaskFields(fieldMaskArray) {
        const fieldMaskMap = new Map(fieldMaskArray.map(item => [item.FieldNo, item]));

        // Merge properties based on FieldNo
        const mergedArray = this.fields.map(field => {
            const mask = fieldMaskMap.get(field.FieldNo);
            return mask ? { ...field, ...mask } : field;
        });

        this.maskedFields = mergedArray;
    }
}

function LoadElement(ElementSource, Element) {
    CurrentLoadedElement = new LoadedElement(ElementSource, Element);
    alert(JSON.stringify(CurrentLoadedElement))
}

function GetSourceElement() {
    if (SourceElement != null) {
        return (SourceElement);
    }

    // Select the ControlAddIn element and attach a container to it to use as reference to display further elements
    ControlAddinElement = $("#controlAddIn");
    ExternalDivElement = $('<div></div>').attr('id', 'TPVSourceContainer').attr('class', 'container');
    SourceElement = ExternalDivElement;
    return (SourceElement);
}

function DisplayElement(ElementSource, DisplayFields) {
    BaseBuildingBlock = GetSourceElement();

    CurrentLoadedElement.MaskFields(DisplayFields);

    alert(JSON.stringify(CurrentLoadedElement))

}

function ThrowError(ErrorText, FieldName) {
    HideSpinner();

    alert(ErrorText);
    $(FieldName).val('');
    $(FieldName).css("borderColor", "red");
    $(FieldName).css("background-color", "lightcoral");
    $(FieldName).focus();
}

function ShowSpinner() {
    $("#overlay").show();
}

function HideSpinner() {
    $("#overlay").hide();
}