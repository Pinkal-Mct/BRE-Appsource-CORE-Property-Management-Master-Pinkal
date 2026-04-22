codeunit 73209624 "SplitCombinePaymentModemail"
{
    procedure SendTenantEmail(Rec: Record "Approval Payment Request")
    var
        EmailBody: Text;
        TempBlob: Codeunit "Temp Blob";
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        customer: Record Customer;
        //  SalesInvHeader: Record "Sales Invoice Header";
        TodayDate: Date;
        Tomail: List of [Text];
        EmailAddress: List of [Text];
        CCMail: List of [Text];
        UserRec: Record User; // Record for User
        Username: Text;
        BCCMail: List of [Text];
        // Record for User Personalization
        TempEmailBody: Text;
        CompanyInfo: Record "Company Information";
        RecRef: RecordRef;
        TenantEmail: List of [Text];
        Subject: Text;

    begin
        customer.SetRange("No.", Rec."Tenant ID");
        if customer.FindFirst() then
            TenantEmail.Add(customer."E-Mail");
        if TenantEmail.Count() = 0 then
            Error('No email address found for the tenant. Email cannot be sent.');
        if CompanyInfo.Get() then begin

            case Rec."Request Type" of
                'Split':
                    begin
                        Subject := 'Payment Request Split Confirmation';
                        EmailMessage.Create(TenantEmail, Subject,
                        '<html>' +
                  '<body>' +
                  '<p>Dear ' + customer.Name + ',</p>' +

                '<p>Your payments have been Split into multiple Installments.</p>' +
                  '<h3>Request Details:</h3>' +
                                    '<p><b>Request Type:</b> ' + Rec."Request Type" + '<br/>' +
                                    '<b>Contract ID:</b> ' + Format(Rec."Contract ID") + '<br/>' +
                                      '<b>Payment Series:</b> ' + Rec."Payment Series" + '<br/>' +
                                      '<b>Payment Mode:</b> ' + Rec."Payment Mode" + '<br/>' +
                                      '<b>Total Amount:</b> ' + Format(Rec."Change Amount") + '<br/>' +
                                      '<b>Due Date:</b> ' + Format(Rec."Due Date") + '<br/>' +
                                      '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +
                  '</body>' +
                  '</html>',
                   true, EmailAddress, BCCMail);
                        Email.Send(EmailMessage);
                    end;
                'Combine':
                    begin
                        Subject := 'Payment Request Combine Confirmation';
                        EmailMessage.Create(TenantEmail, Subject,
                        '<html>' +
                  '<body>' +
                  '<p>Dear ' + customer.Name + ',</p>' +
                        '<p>Your payments have been combined into a single installment.</p>' +
                  '<h3>Request Details:</h3>' +
                                    '<p><b>Request Type:</b> ' + Rec."Request Type" + '<br/>' +
                                    '<b>Contract ID:</b> ' + Format(Rec."Contract ID") + '<br/>' +
                                      '<b>Payment Series:</b> ' + Rec."Payment Series" + '<br/>' +
                                      '<b>Payment Mode:</b> ' + Rec."Payment Mode" + '<br/>' +
                                      '<b>Total Amount:</b> ' + Format(Rec."Change Amount") + '<br/>' +
                                      '<b>Due Date:</b> ' + Format(Rec."Due Date") + '<br/>' +
                                      '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +
                  '</body>' +
                  '</html>',
                   true, EmailAddress, BCCMail);
                        Email.Send(EmailMessage);
                    end;

                'Payment Mode':
                    begin
                        Subject := 'Payment Mode Change Confirmation';
                        EmailMessage.Create(TenantEmail, Subject,
                        '<html>' +
                  '<body>' +
                  '<p>Dear ' + customer.Name + ',</p>' +
                '<p>Your payment mode change request has been successfully processed.</p>' +
                  '<h3>Request Details:</h3>' +
                                    '<p><b>Request Type:</b> ' + Rec."Request Type" + '<br/>' +
                                    '<b>Contract ID:</b> ' + Format(Rec."Contract ID") + '<br/>' +
                                      '<b>Payment Series:</b> ' + Rec."Payment Series" + '<br/>' +
                                      '<b>New Payment Mode:</b> ' + Rec."Payment Mode" + '<br/>' +
                                      '<b>Total Amount:</b> ' + Format(Rec."Change Amount") + '<br/>' +
                                      '<b>Due Date:</b> ' + Format(Rec."Due Date") + '<br/>' +
                                      '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +
                  '</body>' +
                  '</html>',
                   true, EmailAddress, BCCMail);
                        Email.Send(EmailMessage);
                    end;


            end;
        end;
        //EmailMessage.Create();
    end;
}