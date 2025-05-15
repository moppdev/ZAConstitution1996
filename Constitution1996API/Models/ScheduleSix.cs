namespace Constitution1996API.Models
{
    // Models that return the results of spGetScheduleSix_TransitionalArrangements, spGetScheduleSix_Clauses, spGetScheduleSix_Subsections
    // which returns the contents of Schedule 6
    public class ScheduleSix_TransitionalArrangement
    {
        public int SectionID {get; set;}
        public string SectionTitle {get; set;} = "";
        public string? SectionText {get; set;} = null;
    }

    public class ScheduleSix_Clause
    {
        public int SectionID {get; set;}
        public string SubsectionID {get; set;} = "";
        public string ClauseID {get; set;} = "";
        public string ClauseText {get; set;} = "";
    }

    public class ScheduleSix_Subsection
    {
        public int SectionID {get; set;}
        public string SubsectionID {get; set;} = "";
        public string SubsectionText {get; set;} = "";
    }

    // Model that combines the above three to return the entire Schedule's contents
    public class ScheduleSix_Full
    {
        public IEnumerable<ScheduleSix_TransitionalArrangement> TransitionalArrangements {get; set;}
        public IEnumerable<ScheduleSix_Clause> Clauses {get; set;}
        public IEnumerable<ScheduleSix_Subsection>? Subsections {get; set;} = null;

        // constructor that sets the values
        public ScheduleSix_Full(IEnumerable<ScheduleSix_TransitionalArrangement> transitionalArrangements, IEnumerable<ScheduleSix_Clause> clauses,  IEnumerable< ScheduleSix_Subsection>? subsections)
        {
            this.Subsections = subsections;
            this.TransitionalArrangements = transitionalArrangements;
            this.Clauses = clauses;
        }
    }
}