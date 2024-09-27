import random
import pandas as pd
from faker import Faker
from datetime import datetime, timedelta


# Generating Latin American Names
# Initialize Faker
fake = Faker('es_MX')

# Set the seed for reproducibility
random.seed(42)

# Function to generate synthetic data for each table
def generate_location_data(country_city_mapping):
        
    # Create lists for the synthetic data
    locations = []

    # Generate synthetic data
    for country, cities in country_city_mapping.items():
        for city in cities:
            location_id = len(locations) + 1  # Start IDs from 1
            locations.append({
                "location_id": location_id,
                "country": country,
                "city": city
            })

    return pd.DataFrame(locations)

def generate_customer_data(num_records, location_ids):
    customers = []
    for i in range(1, num_records + 1):
        customer = {
            "customer_id": i,
            "location_id": random.choice(location_ids),
            "first_name": fake.first_name(),
            "last_name": fake.last_name(),
        }
        customers.append(customer)
    return pd.DataFrame(customers)

def generate_account_data(num_records, customer_ids):
    accounts = []
    for i in range(1, num_records + 1):
        account = {
            "account_id": i,
            "customer_id": random.choice(customer_ids),
            "created_date": fake.date_between(start_date='-5y', end_date='today'),
            "status": random.choice(["active", "inactive"]),
            "account_number": fake.bban(),
        }
        accounts.append(account)
    return pd.DataFrame(accounts)

def generate_calendar_data(start_date, end_date):
    dates = []
    current_date = start_date
    
    while current_date <= end_date:
        dates.append({
            "date": current_date.date(),
            "year": current_date.year,
            "month": current_date.month,
            "day": current_date.day,
            "quarter": (current_date.month - 1) // 3 + 1,
        })
        current_date += timedelta(days=1)
    return pd.DataFrame(dates)

def generate_insurance_data(num_records, customer_ids):
    insurances = []
    for i in range(1, num_records + 1):
        insurance = {
            "insurance_id": i,
            "customer_id": random.choice(customer_ids),
            "created_date": fake.date_between(start_date='-5y', end_date='today'),
            "policy_number": fake.bban(),
            "coverage_amount": round(random.uniform(1000, 100000), 2),
        }
        insurances.append(insurance)
    return pd.DataFrame(insurances)


# Functions to generate transactions 
# Considering that the account withdrawal never exceeds the current balance of the account

# Function to generate a random date within a range
def generate_random_date(start_date, end_date):
    delta = end_date - start_date  # This will be a timedelta
    random_days = random.randint(0, delta.days)
    return start_date + timedelta(days=random_days)

# Function to generate transfers while maintaining the account balance condition
def generate_transfers(accounts_df, num_transactions=1000, start_date=datetime.today() - timedelta(days=5*365), end_date=datetime.today()):
    transfers_df = pd.DataFrame(columns=['transaction_n', 'account_id', 'transaction_type', 
                                   'amount', 'transaction_requested_date', 
                                   'transaction_requested_at', 'status'])

    start_date = start_date.date()  # Convert to date
    end_date = end_date.date()  # Convert to date

    # Initialize the ID counter
    transaction_count = 1
    
    while transaction_count <= num_transactions:
        # Pick a random account
        account_id = random.choice(accounts_df["account_id"])
        account_created_date = accounts_df[accounts_df["account_id"]==account_id]['created_date'].values[0]
        # Generate a transaction date and timestamp, ensuring it's after the account's created_date
        transaction_date = generate_random_date(account_created_date, end_date)
        transaction_timestamp = datetime.combine(transaction_date, datetime.min.time())+timedelta(
            hours=random.randint(0, 23),
            minutes=random.randint(0, 59),
            seconds=random.randint(0, 59))
        
        # Generate the transaction type
        transaction_type = random.choice(['deposit', 'withdrawal'])

        # Generate a random amount for the transaction
        amount = round(random.uniform(10, 1000), 2)

        # Calculate balance up to that date
        if len(transfers_df) > 0:
            total_deposits = sum(transfers_df[(transfers_df["account_id"]==account_id)&(transfers_df["transaction_type"]=="deposit")&(transfers_df["transaction_requested_date"]<=transaction_date)]["amount"])
            total_withdrawals = sum(transfers_df[(transfers_df["account_id"]==account_id)&(transfers_df["transaction_type"]=="withdrawal")&(transfers_df["transaction_requested_date"]<=transaction_date)]["amount"])
            account_balance = total_deposits - total_withdrawals
        else:
            account_balance = 0

        # It it is a deposit, proceeds to create the transfer
        if transaction_type == 'deposit':
            transfers_df.loc[len(transfers_df)] = [transaction_count, account_id, transaction_type,amount, 
                                                   transaction_date, transaction_timestamp, 'completed']
            
            transaction_count += 1  # Increment the ID for the next transaction

        # It it is a withdrawal proceeds to check if there is enough balance for that date
        elif transaction_type == 'withdrawal' and account_balance >= amount:
            # Only process the withdrawal if there are sufficient funds
            transfers_df.loc[len(transfers_df)] = [transaction_count, account_id, transaction_type,amount, 
                                                   transaction_date, transaction_timestamp, 'completed']
            transaction_count += 1  # Increment the ID for the next transaction

            # Sort the DataFrame by transaction_requested_at


    transfers_df = transfers_df.sort_values(by='transaction_requested_at')

    # Reset the index and create a new transaction_id starting from 1
    transfers_df = transfers_df.reset_index(drop=True)
    transfers_df['transaction_id'] = transfers_df.index + 1  # Starting from 1

    final_columns = ['transaction_id','account_id', 'transaction_type', 'amount',
       'transaction_requested_date', 'transaction_requested_at', 'status']
    
    transfers_df= transfers_df[final_columns]

    return transfers_df

# Generate synthetic data
num_customers = 100
num_accounts = 120
num_insurances = 100
num_transactions = 1000

latin_america_country_city_mapping = {
    "Colombia": ["Bogotá", "Medellín", "Cali", "Barranquilla", "Cartagena"],
    "Peru": ["Lima", "Arequipa", "Trujillo", "Chiclayo", "Piura"],
    "Mexico": ["Mexico City", "Guadalajara", "Monterrey", "Puebla", "Tijuana"],
    "Chile": ["Santiago", "Valparaíso", "Concepción", "La Serena", "Antofagasta"],
    "Ecuador": ["Guayaquil", "Quito", "Cuenca", "Santo Domingo", "Machala"]
}

# Range of dates
start_date=datetime.today() - timedelta(days=5*365)
end_date=datetime.today()

# Create locations
location_data = generate_location_data(latin_america_country_city_mapping)
location_ids = location_data['location_id'].tolist()

# Create customers
customer_data = generate_customer_data(num_customers, location_ids)
customer_ids = customer_data['customer_id'].tolist()

# Create accounts
account_data = generate_account_data(num_accounts, customer_ids)
account_ids = account_data['account_id'].tolist()

# Create calendar data for the last 5 years
calendar_data = generate_calendar_data(start_date=start_date, end_date=end_date)


# Create insurance
insurance_data = generate_insurance_data(num_insurances, customer_ids)

# Generate the synthetic transfer data
transfers_data = generate_transfers(accounts_df=account_data, num_transactions=num_transactions,start_date=start_date,end_date=end_date)


# Display the generated data
print("Location Data:")
print(location_data.head())
print("\nCustomer Data:")
print(customer_data.head())
print("\nAccount Data:")
print(account_data.head())
print("\nCalendar Data:")
print(calendar_data.head())
print("\nInsurance Data:")
print(insurance_data.head())
print("\Transfers Data:")
print(transfers_data.head())

# save to CSV files
location_data.to_csv('bank-warehouse/data/location_data.csv', index=False)
customer_data.to_csv('bank-warehouse/data/customer_data.csv', index=False)
account_data.to_csv('bank-warehouse/data/account_data.csv', index=False)
calendar_data.to_csv('bank-warehouse/data/calendar_data.csv', index=False)
insurance_data.to_csv('bank-warehouse/data/insurance_data.csv', index=False)
transfers_data.to_csv('bank-warehouse/data/transfers_data.csv', index=False)
