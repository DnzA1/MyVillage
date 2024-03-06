public with sharing class CretaeOrder {
    @InvocableMethod (label = 'Create Order' )
    public static void createOrderNew(List<Quote> quotes){
        Quote quo = new Quote();

        if (quotes.size() > 0){
            quo = quotes[0]; 
            createOrders(quo);
        }
        // System.debug(quo);
        System.debug(quo.OpportunityId);
        System.debug(quo.Account.Name);
        System.debug(quo.Name);
    }

    @testVisible
    private static void createOrders(Quote quo){

        try {
        // Quote Line Items Getting
        List<QuoteLineItem> quoteLines = new List<QuoteLineItem>(
                                        [SELECT Id,PricebookEntryId,Quantity,UnitPrice,Product2Id,Product2.name
                                        FROM QuoteLineItem 
                                        WHERE QuoteId = :quo.Id]);

        // Order Part
        Order order = new Order();
        order.Name = quo.Name; 
        order.AccountId = quo.AccountId;
        order.Status = 'Draft';
        order.Pricebook2Id = quo.Pricebook2Id;
        order.QuoteId = quo.Id;
        order.EffectiveDate = Date.today();
        Database.insert(order);
        
        // Order Product Part
        List<OrderItem> linesToAdd = new List<OrderItem>();
        for(QuoteLineItem ql : quoteLines){
            OrderItem orderLine = new OrderItem();
            orderLine.OrderId = order.Id;
            orderLine.PricebookEntryId = ql.PricebookEntryId;
            orderLine.Quantity = ql.Quantity;
            orderLine.UnitPrice = ql.UnitPrice;
            orderLine.Product_Sub_Total__c = ql.UnitPrice;
            linesToAdd.add(orderLine);
        }
        Database.insert(linesToAdd);
        
        AggregateResult aggResult = [SELECT SUM(Product_Sub_Total__c) totalProSub, MAX(Quantity) maxQua FROM OrderItem WHERE orderId =:order.Id];
        // order.Order_Sub_Total__c = (Decimal)aggResult.get('totalProSub');
        // order.Order_Sub_Total__c = (Decimal)aggResult.get('totalProSub')*(Decimal)aggResult.get('maxQua');
        order.Order_Sub_Total__c = (Decimal)aggResult.get('totalProSub')*10;
        Database.update(order);

        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
    }

}