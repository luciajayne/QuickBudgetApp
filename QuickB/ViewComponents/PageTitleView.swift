import SwiftUI

struct PageTitleView: View {
    var title:String
    var isDisplayingTransactions:Bool! = nil //To add an changing arrow for menu displayed if necessary
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.title)
                .fontWeight(.medium)
                .padding(.trailing)
        }.overlay(
            Image(systemName:isDisplayingTransactions ?? false ? "chevron.up.square":"chevron.down.square") //It shows arrows for displaying or colapsing if need on a list (feature used on Project 6 Summary View)
                .font(.title)
                .foregroundColor(isDisplayingTransactions != nil ? Color("G1") : .clear)
            .padding()
            ,alignment: .leading
        )
        .foregroundColor(Color("G1"))
        .background(Color("G3"))
        
    }
}

struct PageTitleView_Previews: PreviewProvider {
    static var previews: some View {
        PageTitleView(title: "Transactions")
    }
}
