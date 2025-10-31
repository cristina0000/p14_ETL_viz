# IMPORT DEPENDENCIES
import oracledb
import pandas as pd
from sqlalchemy import create_engine

# ORACLE DATABASE CREDENTIALS AND CONNECTION SETUP
username = 'SYSTEM'
password = 'YourOraclePassword'
host = 'localhost'
port = 1521
service_name = 'FREEPDB1' # oracle database on Docker container

# CREATE SQLAlchemy CONNECTION 
engine = create_engine(f'oracle+oracledb://{username}:{password}@{host}:{port}/?service_name={service_name}')

# READ DATA FROM DATABASE INTO PANDAS DATAFRAMES

# Get list of relevant tables 
table_query = "SELECT table_name FROM all_tables WHERE table_name LIKE 'PS_%'"
tables_df = pd.read_sql(table_query, con=engine)
print("✅ Available tables:")
print(tables_df)

# Define which tables to load 
target_tables = ["PS_STDNT_ENRL", "PS_CLASS_TBL", "PS_TERM_TBL"]

# Read each table dynamically into a DataFrame 
dataframes = {}

for table_name in target_tables:
    print(f"\n📥 Loading table: {table_name}")
    try:
        query = f"SELECT * FROM SYSADM.{table_name}"
        df = pd.read_sql(query, con=engine)
        dataframes[table_name] = df
        print(f"✅ Loaded {table_name} ({len(df)} rows, {len(df.columns)} columns)")
        print(df.head(5))  # Preview first few rows
    except Exception as e:
        print(f"❌ Failed to load {table_name}: {e}")

# Access DataFrames by name
ps_stdnt_enrl_df = dataframes.get("PS_STDNT_ENRL")
ps_class_tbl_df = dataframes.get("PS_CLASS_TBL")
ps_term_tbl_df = dataframes.get("PS_TERM_TBL")

print("\U00002705 Data loaded successfully!") # or Windows + . (period) to insert any emoji


# Example: print a summary
if ps_stdnt_enrl_df is not None:
    print("\n📊 Enrollment Table Summary:")
    print(ps_stdnt_enrl_df.describe(include='all'))

# DATA TRANSFORMATION 
print ("Student Enrollment Transformation:")
ps_stdnt_enrl_df.info()
ps_stdnt_enrl_df = (
    ps_stdnt_enrl_df
    .drop(['crse_career', 'session_code'], axis=1)
    .drop_duplicates()
    .rename(columns={'emplid': 'student_id', 'strm': 'term_id'})
)
ps_stdnt_enrl_df['class_nbr'] = ps_class_tbl_df['class_nbr'].astype(str)
ps_stdnt_enrl_df.info()

print ("Class table transformation")
ps_class_tbl_df=ps_class_tbl_df.drop_duplicates()
ps_class_tbl_df=ps_class_tbl_df.rename(columns={'strm': 'term_id', 'descr': 'class_descr'})
ps_class_tbl_df['class_nbr'] = ps_class_tbl_df['class_nbr'].astype(str)
ps_class_tbl_df.info()

print ("Term table Transformation:")
ps_term_tbl_df.info()
ps_term_tbl_df = (
    ps_term_tbl_df
    .drop(['institution', 'acad_career'], axis=1)
    .drop_duplicates()
    .rename(columns={'strm': 'term_id', 'descr': 'term_descr'})
)
ps_term_tbl_df.info()

# WRITE DATA BACK TO THE DATABASE

ps_stdnt_enrl_df.to_sql('PS_STDNT_ENRL_CLEAN', con=engine, if_exists='replace', index=False, schema='SYSADM')
ps_class_tbl_df.to_sql('PS_CLASS_TBL_CLEAN', con=engine, if_exists='replace', index=False, schema='SYSADM')
ps_term_tbl_df.to_sql('PS_TERM_TBL_CLEAN', con=engine, if_exists='replace', index=False, schema='SYSADM')
print('✅ Data was loaded back to the database successfully')




