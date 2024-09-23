public class tmdbCastResponse {
    public Integer id { get; set; }
    public List<CastMember> castMember { get; set; }

    public class CastMember {
        public String known_for_department { get; set; }
        public String name { get; set; }
        public String character { get; set; }
    }
}