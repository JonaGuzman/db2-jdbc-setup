describe('Database Tests', () => {
    it('should query the database', () => {
      cy.queryDatabase('SELECT * FROM your_table LIMIT 1')
        .then((results) => {
          expect(results).to.have.length.above(0);
          // Add more assertions based on your data
        });
    });
  });