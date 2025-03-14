page 90511 TableRelationMetadata
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Table Relations Metadata";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the value of the Table ID field.', Comment = '%';
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.', Comment = '%';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.', Comment = '%';
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the value of the Field Name field.', Comment = '%';
                }
                field("Relation No."; Rec."Relation No.")
                {
                    ToolTip = 'Specifies the value of the Relation No. field.', Comment = '%';
                }
                field("Related Table ID"; Rec."Related Table ID")
                {
                    ToolTip = 'Specifies the value of the Related Table ID field.', Comment = '%';
                }
                field("Related Field No."; Rec."Related Field No.")
                {
                    ToolTip = 'Specifies the value of the Related Field No. field.', Comment = '%';
                }
                field("Related Table Name"; Rec."Related Table Name")
                {
                    ToolTip = 'Specifies the value of the Related Table Name field.', Comment = '%';
                }
                field("Related Field Name"; Rec."Related Field Name")
                {
                    ToolTip = 'Specifies the value of the Related Field Name field.', Comment = '%';
                }
                field("Condition No."; Rec."Condition No.")
                {
                    ToolTip = 'Specifies the value of the Condition No. field.', Comment = '%';
                }
                field("Condition Type"; Rec."Condition Type")
                {
                    ToolTip = 'Specifies the value of the Condition Type field.', Comment = '%';
                }
                field("Condition Field No."; Rec."Condition Field No.")
                {
                    ToolTip = 'Specifies the value of the Condition Field No. field.', Comment = '%';
                }
                field("Condition Value"; Rec."Condition Value")
                {
                    ToolTip = 'Specifies the value of the Condition Value field.', Comment = '%';
                }
                field("Test Table Relation"; Rec."Test Table Relation")
                {
                    ToolTip = 'Specifies the value of the Test Table Relation field.', Comment = '%';
                }
                field("Validate Table Relation"; Rec."Validate Table Relation")
                {
                    ToolTip = 'Specifies the value of the Validate Table Relation field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}