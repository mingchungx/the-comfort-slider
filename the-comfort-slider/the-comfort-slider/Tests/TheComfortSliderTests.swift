import Foundation
import Testing
@testable import TheComfortSlider

struct ExpenseFrequencyTests {

    @Test func monthlyIsUnchanged() {
        #expect(ExpenseFrequency.monthly.monthlyAmount(for: 250) == 250)
    }

    @Test func yearlySpreadsOverTwelveMonths() {
        #expect(ExpenseFrequency.yearly.monthlyAmount(for: 1_200) == 100)
    }

    /// Daily and weekly go through the year rather than assuming a 30-day month,
    /// so twelve months of them add up to exactly a year of spending.
    @Test func dailyAndWeeklyAnnualiseExactly() {
        let daily = ExpenseFrequency.daily.monthlyAmount(for: 10)
        #expect(daily * 12 == 10 * 365)

        let weekly = ExpenseFrequency.weekly.monthlyAmount(for: 30)
        #expect(weekly * 12 == 30 * 52)
    }
}

struct AdditionalExpenseTests {

    @Test func blankOrInvalidAmountIsZero() {
        var expense = AdditionalExpense()
        #expect(expense.monthlyAmount == .zero)

        expense.amountText = "abc"
        #expect(expense.amountText.isEmpty)
        #expect(expense.monthlyAmount == .zero)
    }

    @Test func amountTextIsSanitisedOnWrite() {
        var expense = AdditionalExpense()
        expense.amountText = "1.2.3.4"
        #expect(expense.amountText == "1.23")
    }

    @Test func convertsUsingItsOwnFrequency() {
        var expense = AdditionalExpense()
        expense.amountText = "1200"
        expense.frequency = .yearly
        #expect(expense.monthlyAmount == 100)
    }
}

struct AffordabilityCalculatorTests {
    private let calculator = AffordabilityCalculator()

    /// A 0% APR loan is a straight division, which makes the arithmetic checkable
    /// by hand: 12,000 over 12 months is 1,000/mo before any extras.
    @Test func extrasAddToTheMonthlyCostButNotToInterest() {
        let result = calculator.result(
            totalPrice: 12_000,
            downPaymentPercent: 0,
            annualRatePercent: 0,
            months: 12,
            monthlyExtras: 250,
            sliderValue: 50
        )

        #expect(result.monthlyPayment == 1_000)
        #expect(result.monthlyExtras == 250)
        #expect(result.totalMonthlyCost == 1_250)
        #expect(result.totalInterest == .zero)
    }

    /// The comfort math runs on the *total* outflow: at a 20% DTI, a 1,250/mo
    /// commitment implies 15,000/yr of payments against a 75,000 salary.
    @Test func requiredIncomeIsDrivenByTotalMonthlyCost() throws {
        let withExtras = calculator.result(
            totalPrice: 12_000,
            downPaymentPercent: 0,
            annualRatePercent: 0,
            months: 12,
            monthlyExtras: 250,
            sliderValue: 50
        )
        let income = try #require(withExtras.requiredAnnualIncome)
        #expect(withExtras.dtiFraction == 0.2)
        #expect(abs(income - 75_000) < 1)

        let withoutExtras = calculator.result(
            totalPrice: 12_000,
            downPaymentPercent: 0,
            annualRatePercent: 0,
            months: 12,
            monthlyExtras: .zero,
            sliderValue: 50
        )
        let baseIncome = try #require(withoutExtras.requiredAnnualIncome)
        #expect(abs(baseIncome - 60_000) < 1)
    }

    @Test func downPaymentStillOnlyReducesTheFinancedPortion() {
        let result = calculator.result(
            totalPrice: 12_000,
            downPaymentPercent: 50,
            annualRatePercent: 0,
            months: 12,
            monthlyExtras: 100,
            sliderValue: 50
        )

        #expect(result.monthlyPayment == 500)
        #expect(result.totalMonthlyCost == 600)
    }
}

@MainActor
struct CalculatorViewModelTests {

    @Test func extrasAreIgnoredWhileTheFeatureIsOff() {
        let viewModel = CalculatorViewModel()
        viewModel.expenses[0].amountText = "500"

        #expect(viewModel.monthlyExtras == .zero)

        viewModel.expensesEnabled = true
        #expect(viewModel.monthlyExtras == 500)
    }

    @Test func expensesSumAcrossFrequencies() {
        let viewModel = CalculatorViewModel()
        viewModel.expensesEnabled = true
        viewModel.expenses[0].amountText = "300"

        viewModel.addExpense()
        viewModel.expenses[1].amountText = "1200"
        viewModel.expenses[1].frequency = .yearly

        #expect(viewModel.monthlyExtras == 400)
    }

    @Test func theLastRowCannotBeRemoved() {
        let viewModel = CalculatorViewModel()
        #expect(viewModel.canRemoveExpense == false)

        viewModel.addExpense()
        #expect(viewModel.canRemoveExpense)

        viewModel.removeExpense(viewModel.expenses[0].id)
        #expect(viewModel.expenses.count == 1)

        viewModel.removeExpense(viewModel.expenses[0].id)
        #expect(viewModel.expenses.count == 1)
    }
}
