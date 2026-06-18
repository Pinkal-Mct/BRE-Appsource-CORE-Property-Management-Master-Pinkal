codeunit 73209624 "BLRSplitCombinePaymentModemail"
{
    procedure SendTenantEmail(Rec: Record "BLRApprovalPaymentRequest")
    var
        customer: Record Customer;
        CompanyInfo: Record "Company Information";
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        //  SalesInvHeader: Record "Sales Invoice Header";
        EmailAddress: List of [Text];
        BCCMail: List of [Text];
        TenantEmail: List of [Text];
        Subject: Text;

    begin
        customer.SetRange("No.", Rec."BLRTenant ID");
        if customer.FindFirst() then
            TenantEmail.Add(customer."E-Mail");
        if TenantEmail.Count() = 0 then
            Error('No email address found for the tenant. Email cannot be sent.');
        if CompanyInfo.Get() then
            case Rec."BLRRequest Type" of
                'Split':
                    begin
                        Subject := 'Payment Request Split Confirmation';
                        EmailMessage.Create(TenantEmail, Subject,
                        '<html>' +
                  '<body>' +
                  '<p>Dear ' + customer.Name + ',</p>' +

                '<p>Your payments have been Split into multiple Installments.</p>' +
                  '<h3>Request Details:</h3>' +
                                    '<p><b>Request Type:</b> ' + Rec."BLRRequest Type" + '<br/>' +
                                    '<b>Contract ID:</b> ' + Format(Rec."BLRContract ID") + '<br/>' +
                                      '<b>Payment Series:</b> ' + Rec."BLRPayment Series" + '<br/>' +
                                      '<b>Payment Mode:</b> ' + Rec."BLRPayment Mode" + '<br/>' +
                                      '<b>Total Amount:</b> ' + Format(Rec."BLRChange Amount") + '<br/>' +
                                      '<b>Due Date:</b> ' + Format(Rec."BLRDue Date") + '<br/>' +
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
                                    '<p><b>Request Type:</b> ' + Rec."BLRRequest Type" + '<br/>' +
                                    '<b>Contract ID:</b> ' + Format(Rec."BLRContract ID") + '<br/>' +
                                      '<b>Payment Series:</b> ' + Rec."BLRPayment Series" + '<br/>' +
                                      '<b>Payment Mode:</b> ' + Rec."BLRPayment Mode" + '<br/>' +
                                      '<b>Total Amount:</b> ' + Format(Rec."BLRChange Amount") + '<br/>' +
                                      '<b>Due Date:</b> ' + Format(Rec."BLRDue Date") + '<br/>' +
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
                                    '<p><b>Request Type:</b> ' + Rec."BLRRequest Type" + '<br/>' +
                                    '<b>Contract ID:</b> ' + Format(Rec."BLRContract ID") + '<br/>' +
                                      '<b>Payment Series:</b> ' + Rec."BLRPayment Series" + '<br/>' +
                                      '<b>New Payment Mode:</b> ' + Rec."BLRPayment Mode" + '<br/>' +
                                      '<b>Total Amount:</b> ' + Format(Rec."BLRChange Amount") + '<br/>' +
                                      '<b>Due Date:</b> ' + Format(Rec."BLRDue Date") + '<br/>' +
                                      '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +
                  '</body>' +
                  '</html>',
                   true, EmailAddress, BCCMail);
                        Email.Send(EmailMessage);
                    end;


            end;
        //EmailMessage.Create();
    end;
}