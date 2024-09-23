public class MovieWrapper {
        public String id;
        public String name;
        public String tmdb_id;
        public String genre;
        public Decimal rating;
        public Decimal budget;
        public Decimal revenue;
        public String release_date;
        public String status;
		public ScriptWrapper script;
    
    	public class ScriptWrapper {
            public String id;
            public String name;
            public String description;
    	}
    }