//@reference: www.linkedin.com/learning-login/share?account=42275329&forceAccount=false&redirect=https%3A%2F%2Fwww.linkedin.com%2Flearning%2Fswiftui-essential-training%3Ftrk%3Dshare_ent_url%26shareId%3D%252FomLeCqESpidS%252BzXmmhIoA%253D%253D
import SwiftUI

struct RootTabView: View {
    //@Pattern:Singleton (no new object, pass the object instantiated in the class)
    let persistenceContainer = PersistenceController.shared
    //CoreData: unique PersistenceContainer
    @ObservedObject var transactionModel: TransactionModel 
    var body: some View {

        TabView{
            HomeView(transactionModel: transactionModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            SearchView(transactionModel: transactionModel) //Search
                .tabItem{
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)//CoreData uses Environment var
            ContentView(transactionModel: transactionModel)
                .tabItem {
                    Image(systemName: "book")
                    Text("History")
                }
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)//CoreData uses Environment var
            MonthSummaryView(transactionModel: transactionModel)
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("Summary")
                }
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)//CoreData uses Environment var
        }
        .accentColor(Color("G4"))
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView(transactionModel: TransactionModel())
    }
}
